/****** Object:  Procedure [dbo].[sp_save_linkedindata]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:  <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_save_linkedindata]
AS
BEGIN--main start
  SET NOCOUNT ON;
  DECLARE @DuplicateCount int,
          @linkedinid int
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  DECLARE @name varchar(max),
          @url varchar(max),
          @organization varchar(max),
          @designation varchar(max),
          @yearofjoining varchar(max),
          @currentposition varchar(max),
          @city varchar(max),
          @state varchar(max),
          @country varchar(max),
          @summary varchar(max),
          @currentrole varchar(max),
          @previousrole varchar(max),
          @targetcustomer varchar(max),
          @decisionmaker varchar(max),
          @Functionality varchar(100),
          @userid int,
          @keyword varchar(500),
          @FirstName varchar(max),
          @MiddleName varchar(max),
          @LastName varchar(max),
          @education varchar(max),
          @domainname varchar(max),
          @emailid varchar(max),
          @TagId int,
          @phonenumber varchar(max),
          @score int,
          @twitter varchar(max),
          @linkedin_country varchar(max),
          @suggested_domainname varchar(max),
          @GoldCustomer bit,
          @datarating int,
          @fcount int,
          @accuracy int,
          @tagidold int,
          @IsActive bit,
          @OrganizationAccuracy int,
          @keywordType varchar(max),
          @firstsuggested_domainname varchar(max),
          @gender varchar(1),
          @MarketingList varchar(max),
          @TotalRecords int,
          @ErrorRecords int

  DECLARE db_cursor_upload CURSOR LOCAL FOR
  SELECT
    name,
    url,
    organization,
    designation,
    yearofjoining,
    currentposition,
    city,
    state,
    country,
    summary,
    currentrole,
    previousrole,
    targetcustomer,
    'Unknown' decisionmaker,
    Functionality,
    userid,
    keyword,
    FirstName,
    MiddleName,
    LastName,
    education,
    domainname,
    emailid,
    0 TagId,
    phonenumber,
    0 score,
    twitter,
    linkedin_country,
    suggested_domainname,
    0 GoldCustomer,
    0 datarating,
    0 fcount,
    0 accuracy,
    0 tagidold,
    1 IsActive,
    0 OrganizationAccuracy,
    keywordType,
    firstsuggested_domainname,
    'U' gender,
    MarketingList
  FROM StgLinkedinData
  WHERE Row_num > 0
  --
  -- ValidationFirst
  --
  SELECT
    @TotalRecords = COUNT(*)
  FROM StgLinkedinData
  WHERE Row_Num > 0

  SELECT
    @ErrorRecords = COUNT(*)
  FROM StgLinkedinData
  WHERE Row_Num > 0
  AND (LEN(name) = 0
  OR LEN(organization) = 0
  OR LEN(Functionality) = 0
  OR LEN(designation) = 0
  OR LEN(FirstName) = 0
  OR LEN(LastName) = 0
  OR LEN(domainname) = 0
  OR LEN(emailid) = 0
  OR LEN(linkedin_country) = 0
  OR LEN(suggested_domainname) = 0
  OR LEN(keywordType) = 0
  OR LEN(userid) = 0
  OR userid = 0
  OR LEN(firstsuggested_domainname) = 0)
  IF @ErrorRecords IS NULL
    SET @ErrorRecords = 0
  IF @ErrorRecords > 0
    PRINT 'Missing Mandatory Fields name,organization,designation,Functionality,FirstName,LastName,domainname,emailid,linkedin_country,suggested_domainname,keywordType,firstsuggested_domainname,UserID'

  SELECT
    @DuplicateCount = SUM(cnt)
  FROM (SELECT
    COUNT(*) cnt
  FROM StgLinkedinData
  GROUP BY name,
           organization,
           designation
  HAVING COUNT(*) > 1) a
  IF @DuplicateCount IS NULL
    SET @DuplicateCount = 0

  ---IF @DuplicateCount > 0
    ---PRINT 'Duplicate Name,Organization,Designation'

  IF @TotalRecords > 0
    --AND @DuplicateCount = 0
    AND @ErrorRecords = 0
  BEGIN --Begin when valid records
    OPEN db_cursor_upload
    FETCH NEXT FROM db_cursor_upload INTO @name,
    @url,
    @organization,
    @designation,
    @yearofjoining,
    @currentposition,
    @city,
    @state,
    @country,
    @summary,
    @currentrole,
    @previousrole,
    @targetcustomer,
    @decisionmaker,
    @Functionality,
    @userid,
    @keyword,
    @FirstName,
    @MiddleName,
    @LastName,
    @education,
    @domainname,
    @emailid,
    @TagId,
    @phonenumber,
    @score,
    @twitter,
    @linkedin_country,
    @suggested_domainname,
    @GoldCustomer,
    @datarating,
    @fcount,
    @accuracy,
    @tagidold,
    @IsActive,
    @OrganizationAccuracy,
    @keywordType,
    @firstsuggested_domainname,
    @gender,
    @MarketingList
    WHILE @@FETCH_STATUS = 0
    BEGIN--Begin while loop


      INSERT INTO LinkedinData (name,
      url,
      organization,
      designation,
      yearofjoining,
      currentposition,
      city,
      state,
      country,
      summary,
      currentrole,
      previousrole,
      targetcustomer,
      decisionmaker,
      Functionality,
      userid,
      keyword,
      FirstName,
      MiddleName,
      LastName,
      education,
      domainname,
      emailid,
      TagId,
      phonenumber,
      score,
      twitter,
      linkedin_country,
      suggested_domainname,
      GoldCustomer,
      datarating,
      fcount,
      accuracy,
      tagidold,
      IsActive,
      OrganizationAccuracy,
      keywordType,
      firstsuggested_domainname,
      gender)
        VALUES (@name, @url, @organization, @designation, @yearofjoining, @currentposition, @city, @state, @country, @summary, @currentrole, @previousrole, @targetcustomer, @decisionmaker, @Functionality, @userid, @keyword, @FirstName, @MiddleName, @LastName, @education, @domainname, @emailid, @TagId, @phonenumber, @score, @twitter, @linkedin_country, @suggested_domainname, @GoldCustomer, @datarating, @fcount, @accuracy, @tagidold, @IsActive, @OrganizationAccuracy, @keywordType, @firstsuggested_domainname, @gender)

      SET @linkedinid = SCOPE_IDENTITY();

      IF LEN(@MarketingList) > 0
      BEGIN--Begin Of Marketing List
        SELECT TOP 1
          @linkedinid = id
        FROM LinkedInData
        WHERE name = @name
        AND organization = @organization
		AND designation = @designation
        AND UserID = @UserID
        ORDER BY id DESC
        INSERT INTO McDecisionmakerlist (AppUserId
        , DecisionMakerId
        , DecisionMakerlistName
        , IsActive
        , Name
        , Mode)
          VALUES (@userid, @linkedinid, @Name, 1, @MarketingList, 'User Defined List')
      END-- End Of Marketing List
      FETCH NEXT FROM db_cursor_upload INTO @name,
      @url,
      @organization,
      @designation,
      @yearofjoining,
      @currentposition,
      @city,
      @state,
      @country,
      @summary,
      @currentrole,
      @previousrole,
      @targetcustomer,
      @decisionmaker,
      @Functionality,
      @userid,
      @keyword,
      @FirstName,
      @MiddleName,
      @LastName,
      @education,
      @domainname,
      @emailid,
      @TagId,
      @phonenumber,
      @score,
      @twitter,
      @linkedin_country,
      @suggested_domainname,
      @GoldCustomer,
      @datarating,
      @fcount,
      @accuracy,
      @tagidold,
      @IsActive,
      @OrganizationAccuracy,
      @keywordType,
      @firstsuggested_domainname,
      @gender,
      @MarketingList
    END -- End for while loop
    CLOSE db_cursor_upload
    DEALLOCATE db_cursor_upload
	IF @TotalRecords > 0
    PRINT 'Successfully Uploaded LinkedinData'
  END -- End for Valid records
 DELETE StgLinkedinData
END--main end
