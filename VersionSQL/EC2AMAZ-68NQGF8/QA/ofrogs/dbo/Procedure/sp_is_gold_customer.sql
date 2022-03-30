/****** Object:  Procedure [dbo].[sp_is_gold_customer]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Janna>
-- Create date: <8th Jul 2018>
-- Description:    <To Calcualte Data Rating >
-- =============================================
CREATE PROCEDURE [dbo].[sp_is_gold_customer]
-- Add the parameters for the stored procedure here
@id int,
@action varchar(10)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  DECLARE @total_word_count int,
          @current_functionality varchar(max),
          @full_functionality varchar(max),
          @functionality varchar(max),
          @current_summary varchar(max),
          @current_functionality_length int
  DECLARE @current_designation varchar(max),
          @current_organization varchar(max),
		  @title varchar(max),
          @FirstName varchar(100),
		  @Organization varchar(max)
  DECLARE @keyword_position int,
          @keyword_length int
  DECLARE @FuncAfterPreviousWord varchar(1),
          @keywordtype varchar(100)
  DECLARE @PositionOfFunctionalty int,
          @PositionOfPrevious int,
          @PositionOfOrganization int,
          @OrganizationFromFunctionalityColumn varchar(max),
		  @TagID int,
		  @Linkedin_Country  varchar(100), @CountryOfOrigin  varchar(100),@AggressionLevel  varchar(100)
		  SET @AggressionLevel ='None'
  SET @FuncAfterPreviousWord = 'N'
  DECLARE @Motivation VARCHAR(1) 
  SET @Motivation ='N'
  -- Gather required data
  SELECT
    @full_functionality = RTRIM(LTRIM(functionality)),
    @current_functionality = REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(functionality)), ',', ' '), '-', ' '), 'Google Search', ' '),
    @current_summary = REPLACE(REPLACE(RTRIM(LTRIM(summary)), ',', ' '), ' - ', ' '),
    @current_designation = designation,
	@Organization = organization,
    @current_organization = 
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
    END)
	,
    @FirstName = FirstName,
    @keywordtype = keywordtype,
	@Linkedin_Country =   case when len(linkedin_country) > 0 then 
case when linkedin_country ='United States ' then 'United States Of America'
else
substring(linkedin_country,1,len(linkedin_country)-1)
end
else
''
end ,
@title = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), '/', ' '), '(', ' '), ')', ' ') 

  FROM LinkedInData l1
  WHERE l1.id = @id
  SET @functionality = @current_functionality
  CREATE TABLE #Tempkeyword (
    keyword nvarchar(500),
    order_num int,
    keyword_position int,
    keyword_length int
  )
  CREATE TABLE #TempNonOrganizationData (
    keyword nvarchar(500)
  )
  DECLARE @order_num int = 0,
          @i int = 0
  DECLARE @KeywordData varchar(max)
  DECLARE @total_word_count1 int,
          @organization_count1 int
  --
  -- If Keyword Type ='Keyword, Organization' or 'Organization, Keyword'  then take the organization part from this 
  -- and use this data as Organization column for future processing
  -- 
  IF @keywordtype = 'Keyword, Organization'
  BEGIN
    SET @PositionOfOrganization = CHARINDEX(',', @full_functionality) + 1
	If @PositionOfOrganization > 0 
	begin
    SET @OrganizationFromFunctionalityColumn = RTRIM(LTRIM(SUBSTRING(@full_functionality, @PositionOfOrganization, LEN(@full_functionality))))
   SET @KeywordData = RTRIM(LTRIM(SUBSTRING(@full_functionality, 1, CHARINDEX(',', @full_functionality) - 1)))
   print @KeywordData
    INSERT INTO #TempNonOrganizationData (Keyword)
      SELECT
        COLUMNA
      FROM dbo.SplitToRows(@KeywordData,' ')
	  end
  END
  
  --
  -- Find the number of words, keyword, keyword position and keyword length in functionality column
  --
  SET @current_functionality_length = 0
  WHILE (LEN(@current_functionality) > 0)
  BEGIN
    SET @i = @i + 1
    SET @current_functionality_length = @current_functionality_length + 1
    IF CHARINDEX(' ', @current_functionality) > 0 -- some extra keywords are there
    BEGIN
      SET @order_num = @order_num + 1
      SET @keyword_position = CHARINDEX(LTRIM(RTRIM(SUBSTRING(@current_functionality, 1, CHARINDEX(' ', @current_functionality) - 1))), @current_summary)
      SET @keyword_length = LEN(LTRIM(RTRIM(SUBSTRING(@current_functionality, 1, CHARINDEX(' ', @current_functionality) - 1))))
      INSERT INTO #Tempkeyword (keyword, order_num, keyword_position, keyword_length)
        VALUES (LTRIM(RTRIM(SUBSTRING(@current_functionality, 1, CHARINDEX(' ', @current_functionality) - 1))), @order_num, @keyword_position, @keyword_length)
      SET @current_functionality = SUBSTRING(@current_functionality, CHARINDEX(' ', @current_functionality), LEN(@current_functionality))
      SET @current_functionality = LTRIM(RTRIM(@current_functionality))
    END
    ELSE
    IF LEN(@current_functionality) > 0
      AND CHARINDEX(' ', @current_functionality) = 0  --No space, it is final word 
    BEGIN
      SET @order_num = @order_num + 1

      SET @keyword_position = CHARINDEX(LTRIM(RTRIM(@current_functionality)), @current_summary)
      SET @keyword_length = LEN(LTRIM(RTRIM(@current_functionality)))
      INSERT INTO #Tempkeyword (keyword, order_num, keyword_position, keyword_length)
        VALUES (LTRIM(RTRIM(@current_functionality)), @order_num, @keyword_position, @keyword_length)
      SET @current_functionality_length = @current_functionality_length + 1
      SET @current_functionality = NULL
    END
  END
  -- Remove bad characters
  DELETE FROM #Tempkeyword
  WHERE keyword IN (SELECT
      name
    FROM badword)
  DELETE FROM #Tempkeyword
  WHERE keyword LIKE '%site:%'

  -- Find total words
  SELECT
    @total_word_count = COUNT(*)
  FROM #Tempkeyword
  --
  -- Find if organizartion column each keyword exists in summary column based on functionality column
  --
  DECLARE @keyword varchar(max),
          @actual_word_count int
  SET @actual_word_count = 0
  DECLARE db_cursor CURSOR FOR
  SELECT
    keyword,
    order_num
  FROM #Tempkeyword

  OPEN db_cursor
  FETCH NEXT FROM db_cursor INTO @keyword, @order_num

  WHILE @@FETCH_STATUS = 0
  BEGIN

    IF CHARINDEX(LOWER(@keyword), LOWER(@current_summary)) > 0
      OR CHARINDEX(LOWER(@keyword), LOWER(@current_designation)) > 0
      OR CHARINDEX(LOWER(@keyword), LOWER(@current_organization)) > 0
      SET @actual_word_count = @actual_word_count + 1
    FETCH NEXT FROM db_cursor INTO @keyword, @order_num
  END
  CLOSE db_cursor
  DEALLOCATE db_cursor

  DECLARE @OrgAccuracy int,
          @OrgAccuracyPresence int,
          @OrgAccuracyDistance int,
          @organization_count int
  --
  -- Find total number of keywords in summary where only organization is present
  -- Note: @actual_word_count increases based on summary or designation, hence new variable
  --
  SELECT
    @organization_count = COUNT(*)
  FROM #Tempkeyword
  WHERE keyword_position > 0

  --
  -- 50% For Data Presence 
  --
  IF @keywordtype <> 'Keyword, Organization'
    SELECT
      @OrgAccuracyPresence =
                            CASE
                              WHEN CAST(@total_word_count AS float) = 0 THEN 0
                              ELSE CAST(@organization_count AS float) /
                                CAST(@total_word_count AS float) * 50
                            END
  ELSE
  BEGIN
    SELECT
      @total_word_count1 = COUNT(*)
    FROM #Tempkeyword
    WHERE keyword NOT IN (SELECT
      keyword
    FROM #TempNonOrganizationData)
    SELECT
      @organization_count1 = COUNT(*)
    FROM #Tempkeyword
    WHERE keyword_position > 0
    AND keyword NOT IN (SELECT
      keyword
    FROM #TempNonOrganizationData)
	
	print @total_word_count1
    print @organization_count1

    SELECT
      @OrgAccuracyPresence =
                            CASE
                              WHEN CAST(@total_word_count1 AS float) = 0 THEN 0
                              ELSE CAST(@organization_count1 AS float) /
                                CAST(@total_word_count1 AS float) * 50
                            END
  END
  --
  -- 50% For Data Positioning
  --
  DECLARE @min_keyword_pos int,
          @max_keyword_pos int,
          @last_pos int,
          @actual_data varchar(max),
          @words_in_string int--This is the actual words that are present in summary between keywords

  IF @keywordtype <> 'Keyword, Organization'
  BEGIN
    SELECT
      @min_keyword_pos = MIN(keyword_position),
      @max_keyword_pos = MAX(keyword_position)
    FROM #Tempkeyword
    WHERE keyword_position <> 0
    SELECT
      @last_pos = @max_keyword_pos + keyword_length - 1
    FROM #Tempkeyword
    WHERE keyword_position = @max_keyword_pos
    SET @actual_data = SUBSTRING(@current_summary, @min_keyword_pos, @last_pos - @min_keyword_pos + 1)
    SET @actual_data = REPLACE(@actual_data, '-', ' ')
    ;
    WITH CTE
    AS (SELECT
      REPLACE(REPLACE(REPLACE(@actual_data, ' ', '><' -- Note that there are 2 spaces here
      ), '<>', ''
      ), '><', ' '
      ) AS string)

    SELECT
      @words_in_string = LEN(@actual_data) - LEN(REPLACE(@actual_data, ' ', '')) + 1
    FROM CTE
  END
  ELSE
  IF @keywordtype = 'Keyword, Organization'
  BEGIN

    SELECT
      @min_keyword_pos = MIN(keyword_position),
      @max_keyword_pos = MAX(keyword_position)
    FROM #Tempkeyword
    WHERE keyword_position <> 0
    AND keyword NOT IN (SELECT
      keyword
    FROM #TempNonOrganizationData)
    SELECT
      @last_pos = @max_keyword_pos + keyword_length - 1
    FROM #Tempkeyword
    WHERE keyword_position = @max_keyword_pos
    SET @actual_data = SUBSTRING(@current_summary, @min_keyword_pos, @last_pos - @min_keyword_pos + 1)
    SET @actual_data = REPLACE(@actual_data, '-', ' ')
    ;
    WITH CTE
    AS (SELECT
      REPLACE(REPLACE(REPLACE(@actual_data, ' ', '><' -- Note that there are 2 spaces here
      ), '<>', ''
      ), '><', ' '
      ) AS string)

    SELECT
      @words_in_string = LEN(@actual_data) - LEN(REPLACE(@actual_data, ' ', '')) + 1
    FROM CTE
  END
  IF @total_word_count <> 0
  BEGIN
    IF @keywordtype <> 'Keyword, Organization'
      SET @OrgAccuracyDistance = (CAST(@organization_count AS float) / CAST(@total_word_count AS float) * 50) - (@words_in_string - @organization_count)
    ELSE
      SET @OrgAccuracyDistance = (CAST(@organization_count1 AS float) / CAST(@total_word_count1 AS float) * 50) - (@words_in_string - @organization_count1)
  END
  --
  -- Add both 50% to get Final Percentage
  --
 


  SET @OrgAccuracy = @OrgAccuracyDistance + @OrgAccuracyPresence
  DECLARE @Gender varchar(1)

  -- Get The Gender Based on First Name
  SELECT TOP 1
    @Gender =
             CASE
               WHEN pg.gender IN ('M', '1M', '?M') THEN 'M'
               WHEN pg.gender IN ('F', '1F', '?F') THEN 'F'
               ELSE 'U'
             END,
	@CountryOfOrigin =		 CountryOfOrigin
  FROM person_gender pg
  WHERE pg.person_name = @FirstName
  IF @Gender IS NULL
    SET @Gender = 'U'
  If @CountryOfOrigin is null
	SET @CountryOfOrigin = ' '

If @CountryOfOrigin <> @Linkedin_Country and @Gender ='M' and len(@CountryOfOrigin) > 2 
	SET  @AggressionLevel ='Aggressive'
	If @CountryOfOrigin <> @Linkedin_Country and @Gender ='F' and len(@CountryOfOrigin) > 2 
	SET  @AggressionLevel ='SuperAggressive'
	--
	-- 26th Dec 2018 Change Agrression Level Based on Last Name
	--

	If @AggressionLevel ='None'
	begin
	create table #LastName
  (Id int,
  Gender Varchar(1))

  insert into #LastName
  select id,gender from(
    select  li.id,
  li.gender,
  count(pn.country) all_country,
 sum(case when 
  CASE
       WHEN LEN(li.linkedin_country) > 0 THEN CASE
           WHEN li.linkedin_country = 'United States ' THEN 'United States Of America'
           ELSE SUBSTRING(li.linkedin_country, 1, LEN(li.linkedin_country) - 1)
         END
       ELSE ''
     END = Pn.Country then 1 else 0 end) this_country
	  from PersonLastName Pn, LinkedIndata Li
  where pn.lastname = li.lastname 
  and li.AggressionLevel = 'None'
  AND decisionmaker = 'DecisionMaker'
  AND ID = @iD
  	 group by li.id, li.gender)a
	 where this_country = 0

update linkedindata  
	  SET AggressionLevel = 'Aggressive'
  WHERE Gender = 'M'
  AND ID in(Select ID from #LastName)
  	 update linkedindata  
	  SET AggressionLevel = 'SuperAggressive'
  WHERE Gender = 'F'
  AND ID in(Select ID from #LastName)

  DROP TABLE #LastName
  end 
  --
  -- Oct 26, 2018
  -- When keywordtype='Organization' and Functionalty column is present after the word previous in summary column
  -- do not overwrite organization column
  -- 
  IF @keywordtype = 'Organization'
  BEGIN
    SET @PositionOfFunctionalty = CHARINDEX(RTRIM(LTRIM(@functionality)), @current_summary)
    SET @PositionOfPrevious = CHARINDEX('Previous', @current_summary)
    IF @PositionOfFunctionalty > 0
      AND @PositionOfPrevious > 0
      AND @PositionOfFunctionalty > @PositionOfPrevious
      SET @FuncAfterPreviousWord = 'Y'
  END
  IF @keywordtype = 'Keyword, Organization'
  BEGIN
    SET @PositionOfFunctionalty = CHARINDEX(RTRIM(LTRIM(@OrganizationFromFunctionalityColumn)), @current_summary)
    SET @PositionOfPrevious = CHARINDEX('Previous', @current_summary)
    IF @PositionOfFunctionalty > 0
      AND @PositionOfPrevious > 0
      AND @PositionOfFunctionalty > @PositionOfPrevious
      SET @FuncAfterPreviousWord = 'Y'
  END
  -- 
  --
  -- Finaly Update DB
  --
  -- If in chrome plugin "Organization" or 'Keyword, Organization' is selected, Then take the organization name from the functionality column 
  -- and put it in Organization column, when organization accuracy is >= 90 and Word = Previous not present before organization name
  -- 
  declare @industryid int
  SELECT TOP 1 @TagID = tag.id, @industryid =  o.industryid from tag, organization o
  where tag.name collate Latin1_General_CI_AI = @Organization and tag.TagTypeId =1
  and    o.id = tag.organizationid
  print @Organization
  print @tagID
  IF @tagID IS NULL
  SET 
  @tagID = 0

  If @industryid  is null
  set @industryid = 0
  
  SELECT TOP 1 @Motivation ='Y'
  FROM V_Motivation
  WHERE charindex(Motivation,@title) > 0
  DECLARE @EducationLevel VARCHAR(25)
  select top 1 @EducationLevel = EducationLevel from(
 SELECT
    id,
    v.EducationLevelDisplay EducationLevel,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY v.sequence) AS rnum  
  FROM linkedindata li,
       V_Education_Level v
  WHERE CHARINDEX(v.EducationLevel, summary) > 0
  and id = @id) a 


  UPDATE linkedindata
  SET CountryOfOrigin = @CountryOfOrigin,
	  AggressionLevel = @AggressionLevel,
	  TagId = @TagID,
	  industryid = @industryid,
	  Gender = @Gender,
      datarating = @actual_word_count,
      fcount = @total_word_count,
      accuracy =
                CASE
                  WHEN CAST(@total_word_count AS float) = 0 THEN 0
                  ELSE CAST(@actual_word_count AS float) /
                    CAST(@total_word_count AS float) * 100
                END,
      OrganizationAccuracy = ISNULL(@OrgAccuracy, 0),
	  resultantcountry = rtrim(replace(linkedin_country, char(160),char(32))),
	  Motivation = @Motivation,
	  EducationLevel = @EducationLevel
	  --,
   --   Organization =
   --                 CASE
   --                   WHEN keywordtype = 'Organization' AND
   --                     ISNULL(@OrgAccuracy, 0) >= 90 AND
   --                     @FuncAfterPreviousWord = 'N' THEN Functionality COLLATE Latin1_General_CI_AS
   --                   WHEN keywordtype = 'Keyword, Organization' AND
   --                     ISNULL(@OrgAccuracy, 0) >= 90 AND
   --                     @FuncAfterPreviousWord = 'N' THEN @OrganizationFromFunctionalityColumn--Just the Organization Name Excluding Keyword Part
   --                   ELSE Organization
   --                 END
  WHERE id = @id
--
  -- Populate Marketing List and Seniority Level For This New Profile
  --
  IF @action ='I'
  begin
  EXEC Sp_Get_LinkedinData_SeniorityLevel @id,@Title
  EXEC sp_get_linkedindata_marketinglist @id
  end 
  
END
