/****** Object:  Procedure [dbo].[sp_update_linkedindata_tag_per_userid]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_linkedindata_tag_per_userid]
@UserId int
AS
BEGIN
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

    DECLARE @id int,
            @organization varchar(500),
            @OriginalOrganization varchar(500),
            @Percentage float,
            @TagID int,
            @ValidTagID int,
            @TagName varchar(500),
            @actualtagwords int,
            @tagwordsinlidata int,
            @totalwordsinlidata int,
            @OrganizationFirstCharacters varchar(15),
            @Organization_Sequence_No int,
            @FirstWordInOrganization varchar(200),
			@IndustryID Int

    -- DELETE TempTagSplit

    DECLARE db_cursor_tag CURSOR FOR
    SELECT 
        id,
        (CASE
            WHEN organization LIKE '%.' AND
                LEN(organization) > 2 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 1)
            WHEN organization LIKE '%..' AND
                LEN(organization) > 3 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 2)
            WHEN organization LIKE '%...' AND
                LEN(organization) > 4 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 3)
            WHEN organization LIKE '% ' AND
                LEN(organization) > 2 THEN SUBSTRING(organization, 1, DATALENGTH(organization) - 1)
            ELSE organization
        END) organization
    FROM linkedindata
    WHERE DATALENGTH(organization) >= 2
    AND tagid = 0
    AND organization NOT IN ('City of ...', 'County of ...', 'State of ...', 'Port of ...', '   ...', ' . ', ' , ', ' . .  ', '  ...', ', ', ' ...',
    'The ...', 'Airports ...', 'United ...', ' Air ...', 'American ...', 'Royal ...', 'Virgin ...', 'Self ...', 'Self Employed.', 'Gulf ...', 'IT ...', 'Founder', 'Self-Employed.', 'n/a', 'Owner')
	AND organization not like '% of'
    AND id NOT IN (SELECT
        id
		FROM lidata_no_tag)
		AND UserID = @UserId
 

    OPEN db_cursor_tag
    FETCH NEXT FROM db_cursor_tag INTO @id, @organization

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -----
        SET @OriginalOrganization = RTRIM(LTRIM(REPLACE(@organization, '&', 'and')))

        SET @OrganizationFirstCharacters = SUBSTRING(@OriginalOrganization, 1, 7)
        SET @Organization_Sequence_No = 0
		SET @organization= (SUBSTRING(@organization, (CASE
        WHEN @organization LIKE 'The %' THEN 5
        WHEN @organization LIKE 'Saint %' THEN 7
        WHEN @organization LIKE 'St %' THEN 4
        WHEN @organization LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(@organization)))

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
            RN = ROW_NUMBER() OVER (PARTITION BY keyword ORDER BY keyword, ORDER_NUM)
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
                REPLACE((SUBSTRING(name, (CASE
        WHEN name LIKE 'The %' THEN 5
        WHEN name LIKE 'Saint %' THEN 7
        WHEN name LIKE 'St %' THEN 4
        WHEN name LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(name))), '&', 'and')
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
        DECLARE db_cursor_tag_tag CURSOR FOR
        SELECT
            TagId,
            TagName
        FROM #TempTag

        OPEN db_cursor_tag_tag
        FETCH NEXT FROM db_cursor_tag_tag INTO @TagId, @TagName

        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO #TempTagSplit (tagid, tagname, keyword)
                SELECT
                    @TagId,
                    @TagName,
                    value
                FROM STRING_SPLIT(@TagName, ' ')
            FETCH NEXT FROM db_cursor_tag_tag INTO @TagId, @TagName
        END
        CLOSE db_cursor_tag_tag
        DEALLOCATE db_cursor_tag_tag
    ---- End  of split of tag data
    BEGIN
        BEGIN TRY
            UPDATE #TempkeywordData
            SET keyword =
                         CASE
                             WHEN SUBSTRING(keyword, LEN(keyword), 1) IN (' ', ',', '.') THEN SUBSTRING(keyword, 1, LEN(keyword) - 1)
                             ELSE keyword
                         END
        END TRY
        BEGIN CATCH
            INSERT INTO lidataerror
                VALUES (@id)
        END CATCH

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


        DELETE #TempPct
	
		INSERT INTO #TempPct
            SELECT
                id,
                (CASE
                    WHEN
                        @FirstWordInOrganization <> FirstWordInTag THEN 0
                    ELSE (CAST(tagwordsinlidata AS float) / CAST(actualtagwords AS float) * 100)
                END),--pct,
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
            AND (REPLACE((SUBSTRING(name, (CASE
        WHEN name LIKE 'The %' THEN 5
        WHEN name LIKE 'Saint %' THEN 7
        WHEN name LIKE 'St %' THEN 4
        WHEN name LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(name))), '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
            OR REPLACE((SUBSTRING(name, (CASE
        WHEN name LIKE 'The %' THEN 5
        WHEN name LIKE 'Saint %' THEN 7
        WHEN name LIKE 'St %' THEN 4
        WHEN name LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(name))), '&', 'and') LIKE td.keyword COLLATE Latin1_General_CI_AI + ' %'
            OR REPLACE((SUBSTRING(name, (CASE
        WHEN name LIKE 'The %' THEN 5
        WHEN name LIKE 'Saint %' THEN 7
        WHEN name LIKE 'St %' THEN 4
        WHEN name LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(name))), '&', 'and') LIKE '% ' + td.keyword COLLATE Latin1_General_CI_AI
            OR (CHARINDEX(name, ' ') = 0
            AND name = td.keyword COLLATE Latin1_General_CI_AI)
            OR -- For GlobalLogic, Inc. Tag and  GlobalLogic as Organization
            (
            RTRIM(LTRIM(REPLACE(REPLACE((SUBSTRING(name, (CASE
        WHEN name LIKE 'The %' THEN 5
        WHEN name LIKE 'Saint %' THEN 7
        WHEN name LIKE 'St %' THEN 4
        WHEN name LIKE 'St. %' THEN 5
        ELSE 1
    END), LEN(name))), '&', 'and'), ', ', ' '))) LIKE '%' + td.keyword COLLATE Latin1_General_CI_AI + ' %'
            ))
            AND t.id = ttag.TagId) sub
         
        --DELETE TempPct
        --INSERT INTO TempPct
        --    SELECT
        --        *
        --    FROM #TempPct

        --DELETE TempkeywordData
        --DELETE temptag
        --INSERT INTO TempkeywordData
        --    SELECT
        --        *
        --    FROM #TempkeywordData
        --INSERT INTO temptag
        --    SELECT
        --        *
        --    FROM #temptag 

       SET @ValidTagID = null

        SELECT TOP 1
			@IndustryId = o.IndustryId,
            @ValidTagID = ValidTagID,
            @Percentage = Percentage,
            @actualtagwords = actualtagwords,
            @tagwordsinlidata = tagwordsinlidata,
            @totalwordsinlidata = totalwordsinlidata
        FROM #TempPct t, Tag t, Organization O
		where t.ValidTagID = t.ID
		and t.OrganizationId=o.id
        ORDER BY 2 DESC, 3 DESC
		If @IndustryId is null 
		set @IndustryId = 0
		IF @ValidTagID IS NOT NULL
        BEGIN
               IF (@totalwordsinlidata = @actualtagwords
                AND @Percentage = 100)
                UPDATE linkedindata
                SET tagid = @ValidTagID,
				IndustryID=@IndustryID
                WHERE id = @id
            ELSE IF @totalwordsinlidata <> @actualtagwords
                AND @Percentage > 66
                AND LOWER(@OrganizationFirstCharacters) <> 'city of'
                UPDATE linkedindata
                SET tagid = @ValidTagID,
				IndustryID=@IndustryID
                WHERE id = @id
			ELSE
			INSERT INTO lidata_no_tag
                VALUES (@id)
			
        END
        IF @ValidTagID IS  NULL 
		     INSERT INTO lidata_no_tag
                VALUES (@id)
		 --
		FETCH NEXT FROM db_cursor_tag INTO @id, @organization
        DELETE #TempkeywordData
        DELETE #TempTag
        DELETE #TempTagSplit
    END
    CLOSE db_cursor_tag
    DEALLOCATE db_cursor_tag
    DROP TABLE #TempkeywordData
    DROP TABLE #TempTag
    DROP TABLE #TempTagSplit
    DROP TABLE #TempPct
END
