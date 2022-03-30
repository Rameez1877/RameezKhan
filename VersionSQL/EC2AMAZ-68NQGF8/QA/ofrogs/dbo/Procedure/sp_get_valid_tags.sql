/****** Object:  Procedure [dbo].[sp_get_valid_tags]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_valid_tags]
-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    CREATE TABLE #TempkeywordData (
        linkedindataid int,
        keyword varchar(500),
        order_num int
    )
    CREATE TABLE #TempTag (
        Tagid int,
        TagName varchar(500),
        keywordcount int,
        pct int,
        order_num int,
        FirstWordInTag varchar(500)
    )
    CREATE TABLE #TempTagSplit (
        Tagid int,
        TagName varchar(500),
        keyword varchar(500),
        order_num int IDENTITY (1, 1)
    )
    CREATE TABLE #TempPct (
        ValidTagID int,
        Percentage float,
        actualtagwords int,
        tagwordsinlidata int,
        totalwordsinlidata int
    )
    DECLARE @organization varchar(500),
            @Organization_Sequence_No int,
            @OriginalOrganization varchar(500),
            @TagID int,
            @TagName varchar(500),
			@FirstWordInOrganization varchar(200)
    SELECT
        @organization = (CASE
            WHEN organization LIKE '%.' AND
                LEN(organization) > 2 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 1)
            WHEN organization LIKE '%..' AND
                LEN(organization) > 3 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 2)
            WHEN organization LIKE '%...' AND
                LEN(organization) > 4 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 3)
            WHEN organization LIKE '% ' AND
                LEN(organization) > 2 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 1)
            ELSE organization
        END)
    FROM linkedindata
    WHERE id = @id

    SET @OriginalOrganization = RTRIM(LTRIM(REPLACE(@organization, '&', 'and')))

    SET @Organization_Sequence_No = 0

    WHILE (LEN(@organization) > 0)

    BEGIN
        SET @Organization_Sequence_No = @Organization_Sequence_No + 1

        IF CHARINDEX(' ', @organization) > 0 -- some extra keywords are there
        BEGIN
        BEGIN TRY
            INSERT INTO #TempkeywordData (linkedindataid, keyword, Order_Num)
                VALUES (@id, LTRIM(RTRIM(SUBSTRING(@organization, 1, CHARINDEX(' ', @organization) - 1))), @Organization_Sequence_No)
            SET @organization = SUBSTRING(@organization, CHARINDEX(' ', @organization), LEN(@organization))
            SET @organization = LTRIM(RTRIM(@organization))

        END TRY
        BEGIN CATCH
            INSERT INTO lidataerror
                VALUES (@id)
        END CATCH
        END
        ELSE
        IF LEN(@organization) > 0
            AND CHARINDEX(' ', @organization) = 0  --No space, it is final word 
        BEGIN
        BEGIN
            INSERT INTO #TempkeywordData (linkedindataid, keyword, Order_Num)
                VALUES (@id, LTRIM(RTRIM(@organization)), @Organization_Sequence_No)
            SET @organization = NULL
        END
        END
    END

    DELETE #TempkeywordData
    WHERE keyword IN ('.', '..', '...', '')
    ;
    -- Delete Duplicate Keywords
    WITH CTE
    AS (SELECT
        keyword,
        RN = ROW_NUMBER() OVER (PARTITION BY keyword ORDER BY keyword, order_num)
    FROM #TempkeywordData)
    DELETE FROM CTE
    WHERE RN > 1

	 SELECT
            @FirstWordInOrganization = keyword
        FROM #TempkeywordData
        WHERE order_num = (SELECT
            MIN(order_num)
        FROM #TempkeywordData
		where linkedindataid =@id)

    INSERT INTO #TempTag (Tagid, TagName)
        SELECT
        DISTINCT
            id,
            REPLACE(name, '&', 'and')
        FROM tag t,
             #TempkeywordData td
        WHERE tagtypeid = 1
        AND (REPLACE(name, '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
        OR REPLACE(name, '&', 'and') LIKE td.keyword COLLATE Latin1_General_CI_AI + ' %'
        OR REPLACE(name, '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI
        OR (--For Single Word Tag and Organization
        CHARINDEX(name, ' ') = 0
        AND name = td.keyword COLLATE Latin1_General_CI_AI)
        OR -- For 'GlobalLogic, Inc.' Tag and  'GlobalLogic' as Organization
        (
        RTRIM(LTRIM(REPLACE(REPLACE(name, '&', 'and'), ', ', ' '))) LIKE '%' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
        ))

    ---- start of split of tag data
    DECLARE db_cursor_tag CURSOR FOR
    SELECT
        TagId,
        TagName
    FROM #TempTag

    OPEN db_cursor_tag
    FETCH NEXT FROM db_cursor_tag INTO @TagId, @TagName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #TempTagSplit (tagid, tagname, keyword)
            SELECT
                @TagId,
                @TagName,
                value
            FROM STRING_SPLIT(@TagName, ' ')
        FETCH NEXT FROM db_cursor_tag INTO @TagId, @TagName
    END
    CLOSE db_cursor_tag
    DEALLOCATE db_cursor_tag
    ---- End  of split of tag data
    UPDATE #TempkeywordData
    SET keyword =
                 CASE
                     WHEN SUBSTRING(keyword, LEN(keyword), 1) IN (' ', ',', '.') THEN SUBSTRING(keyword, 1, LEN(keyword) - 1)
                     ELSE keyword
                 END

    UPDATE #temptag
    SET keywordcount = (SELECT
        COUNT(*)
    FROM #TempTagSplit t2
    WHERE #temptag.TagID = T2.TagId)

    UPDATE #temptag
    SET order_num = (SELECT
        MIN(order_num)
    FROM #TempTagSplit t2
    WHERE #temptag.TagID = T2.TagId)

    UPDATE #temptag
    SET FirstWordInTag = (SELECT
        keyword
    FROM #TempTagSplit t2
    WHERE #temptag.TagID = T2.TagId
    AND #temptag.order_num = t2.order_num)

	DELETE FROM #temptag
	WHERE tagname not like @FirstWordInOrganization +'%'

    DELETE #TempPct
    INSERT INTO #TempPct
        SELECT
            id,
            (CAST(tagwordsinlidata AS float) / CAST(actualtagwords AS float) * 100) pct,
            actualtagwords,
            tagwordsinlidata,
            totalwordsinlidata
        FROM (SELECT
        DISTINCT
            t.id,
            ttag.keywordcount AS actualtagwords,
            (SELECT
                COUNT(*)
            FROM (SELECT
                value
            FROM STRING_SPLIT(name, ' ')) t
            WHERE value IN (SELECT
                keyword COLLATE SQL_Latin1_General_CP1_CI_AS
            FROM #TempkeywordData))
            AS tagwordsinlidata,
            (SELECT
                COUNT(*)
            FROM #TempkeywordData)
            AS totalwordsinlidata,
            t.name AS tagname,
            ttag.FirstWordInTag
        FROM tag t,
             #TempkeywordData td,
             #temptag ttag
        WHERE tagtypeid = 1
        AND (REPLACE(name, '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
        OR REPLACE(name, '&', 'and') LIKE td.keyword COLLATE Latin1_General_CI_AI + ' %'
        OR REPLACE(name, '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI
        OR (CHARINDEX(name, ' ') = 0
        AND name = td.keyword COLLATE Latin1_General_CI_AI)
        OR -- For GlobalLogic, Inc. Tag and  GlobalLogic as Organization
        (
        RTRIM(LTRIM(REPLACE(REPLACE(name, '&', 'and'), ', ', ' '))) LIKE '%' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
        ))
        AND t.id = ttag.TagId) sub
    SELECT
        ValidTagID,
        tag.name AS tagname
    FROM #TempPct tt,
         tag
    WHERE Percentage >= 50
    AND tt.validtagid = tag.id
END
