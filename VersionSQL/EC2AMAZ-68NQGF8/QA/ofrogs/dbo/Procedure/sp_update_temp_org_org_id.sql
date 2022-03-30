/****** Object:  Procedure [dbo].[sp_update_temp_org_org_id]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_update_temp_org_org_id]
AS
BEGIN
  CREATE TABLE #TempkeywordDataOrg (
    keyword varchar(500),
    order_num int
  )
  CREATE TABLE #TempTagOrgOrg (
    Tagid int,
    TagName varchar(500),
    keywordcount int,
    pct int,
    order_num int,
    FirstWordInTag varchar(500)
  )
  CREATE TABLE #TempTagOrgOrgSplit (
    Tagid int,
    TagName varchar(500),
    keyword varchar(500),
    order_num int IDENTITY (1, 1)
  )
  CREATE TABLE #TempPctOrg (
    ValidTagID int,
    Percentage float,
    actualtagwords int,
    tagwordsinlidata int,
    totalwordsinlidata int
  )

  DECLARE @organization varchar(500),
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
          @ActualOrganization varchar(500)


  DECLARE db_cursor_tag CURSOR FOR

  select distinct (CASE
      WHEN company LIKE '%.' AND
        LEN(company) > 2 THEN SUBSTRING(company, 1, DATALENGTH(company) - 1)
      WHEN company LIKE '%..' AND
        LEN(company) > 3 THEN SUBSTRING(company, 1, DATALENGTH(company) - 2)
      WHEN company LIKE '%...' AND
        LEN(company) > 4 THEN SUBSTRING(company, 1, DATALENGTH(company) - 3)
      WHEN company LIKE '% ' AND
        LEN(company) > 2 THEN SUBSTRING(company, 1, DATALENGTH(company) - 1)
      ELSE company
    END) organization,
    company ActualOrganization 
	from temp_org  where company not in (select name collate Latin1_General_CI_AI from tag)
	and ((of_organizationid is null and updatetype is null ) or (of_organizationid is null and updatetype <> 'Could No Get Data'))


-- update temp_org set OF_OrganizationID = 
--(select OrganizationID from tag t where t.name collate SQL_Latin1_General_CP1_CI_AS =  temp_org.Company and tagtypeid=1)
--  update temp_org set ExactMatch = 'Y', updatetype='Direct'
--where exists
--(select OrganizationID from tag t where t.name collate SQL_Latin1_General_CP1_CI_AS =  temp_org.Company and tagtypeid=1)


  OPEN db_cursor_tag
  FETCH NEXT FROM db_cursor_tag INTO @organization, @ActualOrganization

  WHILE @@FETCH_STATUS = 0
  BEGIN
    -----
    SET @OriginalOrganization = RTRIM(LTRIM(REPLACE(@organization, '&', 'and')))

    SET @OrganizationFirstCharacters = SUBSTRING(@OriginalOrganization, 1, 7)
    SET @Organization_Sequence_No = 0
    SET @organization = (SUBSTRING(@organization, (CASE
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
        INSERT INTO #TempkeywordDataOrg (keyword, Order_Num)
          VALUES (LTRIM(RTRIM(SUBSTRING(@organization, 1, CHARINDEX(' ', @organization) - 1))), @Organization_Sequence_No)
        SET @organization = SUBSTRING(@organization, CHARINDEX(' ', @organization), LEN(@organization))
        SET @organization = LTRIM(RTRIM(@organization))


      END
      ELSE
      IF LEN(@organization) > 0
        AND CHARINDEX(' ', @organization) = 0  --No space, it is final word 
      BEGIN
      BEGIN
        INSERT INTO #TempkeywordDataOrg (keyword, Order_Num)
          VALUES (LTRIM(RTRIM(@organization)), @Organization_Sequence_No)
        SET @organization = NULL
      END
      END
    END

    DELETE #TempkeywordDataOrg
    WHERE keyword IN ('.', '..', '...', '')
    ;
    -- Delete Duplicate Keywords
    WITH CTE
    AS (SELECT
      keyword,
      RN = ROW_NUMBER() OVER (PARTITION BY keyword ORDER BY keyword, ORDER_NUM)
    FROM #TempkeywordDataOrg)
    DELETE FROM CTE
    WHERE RN > 1

    SELECT
      @FirstWordInOrganization = keyword
    FROM #TempkeywordDataOrg
    WHERE order_num = (SELECT
      MIN(order_num)
    FROM #TempkeywordDataOrg)


    INSERT INTO #TempTagOrgOrg (Tagid, TagName)
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
           #TempkeywordDataOrg td
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
    FROM #TempTagOrgOrg

    OPEN db_cursor_tag_tag
    FETCH NEXT FROM db_cursor_tag_tag INTO @TagId, @TagName

    WHILE @@FETCH_STATUS = 0
    BEGIN
      INSERT INTO #TempTagOrgOrgSplit (tagid, tagname, keyword)
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
    UPDATE #TempkeywordDataOrg
    SET keyword =
                 CASE
                   WHEN SUBSTRING(keyword, LEN(keyword), 1) IN (' ', ',', '.') THEN SUBSTRING(keyword, 1, LEN(keyword) - 1)
                   ELSE keyword
                 END
  END
    UPDATE #TempTagOrgOrg
    SET keywordcount = (SELECT
      COUNT(*)
    FROM #TempTagOrgOrgSplit t2
    WHERE #TempTagOrgOrg.TagID = T2.TagId)

    UPDATE #TempTagOrgOrg
    SET order_num = (SELECT
      MIN(order_num)
    FROM #TempTagOrgOrgSplit t2
    WHERE #TempTagOrgOrg.TagID = T2.TagId)

    UPDATE #TempTagOrgOrg
    SET FirstWordInTag = (SELECT
      keyword
    FROM #TempTagOrgOrgSplit t2
    WHERE #TempTagOrgOrg.TagID = T2.TagId
    AND #TempTagOrgOrg.order_num = t2.order_num)

    DELETE #TempPctOrg
    INSERT INTO #TempPctOrg
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
        FROM #TempkeywordDataOrg))
        AS tagwordsinlidata,
        (SELECT
          COUNT(*)
        FROM #TempkeywordDataOrg)
        AS totalwordsinlidata,
        t.name AS tagname,
        ttag.FirstWordInTag
      FROM tag t,
           #TempkeywordDataOrg td,
           #TempTagOrgOrg ttag
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

    SET @ValidTagID = NULL

    SELECT TOP 1
      @ValidTagID = ValidTagID,
      @Percentage = Percentage,
      @actualtagwords = actualtagwords,
      @tagwordsinlidata = tagwordsinlidata,
      @totalwordsinlidata = totalwordsinlidata
	FROM #TempPctOrg t1, Tag t2, Organization O
	where t1.ValidTagID = t2.id
	and t2.OrganizationID = o.id
    ORDER BY 2 DESC, 3 DESC
	
	declare @OrgID Int
    IF @ValidTagID IS NOT NULL
    BEGIN
	select @OrgID = OrganizationID from tag where id = @ValidTagID

      IF (@totalwordsinlidata = @actualtagwords
        AND @Percentage = 100)
        UPDATE Temp_Org
        SET OF_OrganizationID = @OrgID,
		UpdateType = 'Fuzzy'
        WHERE Company = @ActualOrganization
        
      ELSE
      IF @totalwordsinlidata <> @actualtagwords
        AND @Percentage > 66
        AND LOWER(@OrganizationFirstCharacters) <> 'city of'
        UPDATE Temp_Org
        SET OF_OrganizationID = @OrgID,
		UpdateType = 'Fuzzy'
        WHERE Company = @ActualOrganization
      
    END
   	IF @ValidTagID IS  NULL
	 UPDATE Temp_Org
        SET OF_OrganizationID =null,
		UpdateType ='Could No Get Data'
        WHERE Company = @ActualOrganization
    FETCH NEXT FROM db_cursor_tag INTO @organization, @ActualOrganization
    DELETE #TempkeywordDataOrg
    DELETE #TempTagOrgOrg
    DELETE #TempTagOrgOrgSplit
  END
  CLOSE db_cursor_tag
  DEALLOCATE db_cursor_tag
  DROP TABLE #TempkeywordDataOrg
  DROP TABLE #TempTagOrgOrg
  DROP TABLE #TempTagOrgOrgSplit
  DROP TABLE #TempPctOrg
END
