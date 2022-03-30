/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList28022020]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList] @MarketingListId int, @UserId int
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      

BEGIN
  DECLARE @AppRoleID int,
          @locations varchar(4000),
          @functionality varchar(4000),
          @seniority varchar(4000)
  DECLARE @delimiter varchar(1) = ',',
          @InputParameter nvarchar(max),
          @xml AS xml

  SELECT
    @AppRoleID = A.AppRoleID
  FROM AppUser A
  WHERE A.Id = @UserId

  SELECT
    @locations = locations,
    @functionality = functionality,
    @seniority = seniority
  FROM MarketingLists
  WHERE ID = @MarketingListId

  CREATE TABLE #Country (
    CountryName varchar(200)
  )
  CREATE TABLE #functionality (
    value varchar(500)
  )
  CREATE TABLE #seniority (
    value varchar(500)
  )

  IF LEN(@locations) > 0
  BEGIN
    SET @InputParameter = @Locations

    SET @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
    INSERT INTO #Country
      SELECT
        C.value('.', 'varchar(2000)') AS [value]
      FROM @xml.nodes('X') AS X (C)

  END

  IF LEN(@functionality) > 0
  BEGIN
    SET @InputParameter = @functionality

    SET @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
    INSERT INTO #functionality
      SELECT
        C.value('.', 'varchar(2000)') AS [value]
      FROM @xml.nodes('X') AS X (C)

  END
  IF LEN(@seniority) > 0
  BEGIN
    SET @InputParameter = @seniority

    SET @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
    INSERT INTO #seniority
      SELECT
        C.value('.', 'varchar(2000)') AS [value]
      FROM @xml.nodes('X') AS X (C)

  END


  SELECT
    li.Id,
    li.Gender,
    li.FirstName,
    li.LastName,
    li.[Name] + ', ' + li.Designation AS [Username],
    li.[Name],
    li.Designation,
    o.name AS Organization,
    o.Revenue,
    o.EmployeeCount,
   -- v.FunctionalityDisplay AS [Functionality],
	mc.[Name] AS [Functionality],
    i.name AS industryName,
    s.EmailId,
	s.Phone,
	s.LinkedinId,
    --li.EmailVerificationStatus,
    RTRIM(li.ResultantCountry) AS Country,
    li.[Url],
    --ls.TotalScore LeadScore,
    ml.MarketingListName,
    li.senioritylevel INTO #Temp1
  FROM dbo.LinkedInData li WITH (NOLOCK)
  INNER JOIN dbo.Tag T
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)
  INNER JOIN dbo.MarketingLists ml WITH (NOLOCK)
    ON (ml.id = @MarketingListId)
  INNER JOIN dbo.Organization o
    ON (o.id = t.organizationid)
  INNER JOIN dbo.Industry i
    ON (o.industryid = i.Id)
  INNER JOIN dbo.McDecisionMakerList mc
    ON (li.Id = mc.DecisionMakerId)
  --INNER JOIN dbo.V_Functionality v
  --  ON (v.Functionality = mc.[Name])
	 left outer join SurgeContactDetail s
  on (li.id = s.linkedinId)
  and s.UserId = @UserId
  and s.Source = 'Target Accounts'
  --LEFT OUTER JOIN leadscore ls
  --  ON (ls.userid = @UserId)
  --  AND ls.organizationid = o.id
  --  AND ls.type = 'Non App')
  WHERE li.id IN (SELECT
    DecisionMakerId
  FROM DecisionMakersForMarketingList
  WHERE MarketingListId = @MarketingListId)
 -- AND RTRIM(li.ResultantCountry) <> ''
    AND mc.name  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )--27jan2020
      AND (li.ResultantCountry)IN (Select Name from UserTargetCountry U, Country C 
	  WHERE UserId = @UserId and u.countryid=c.id )
	   -- AND li.SeniorityLevel IN ('C-Level', 'Director')
	   AND  li.SeniorityLevel IN (select seniority from UserTargetSeniority where userid=@UserId)
	 
    

  IF LEN(@locations) > 0
    DELETE FROM #temp1
    WHERE Country NOT IN (SELECT
        countryname
      FROM #Country)

  IF LEN(@functionality) > 0
    DELETE FROM #temp1
    WHERE functionality NOT IN (SELECT
        value
      FROM #functionality)

  IF LEN(@Seniority) > 0
    DELETE FROM #temp1
    WHERE SeniorityLevel NOT IN (SELECT
        value
      FROM #Seniority)

  IF @AppRoleID <> 3
    SELECT
      *
    FROM #temp1
    --ORDER BY LeadScore DESC
  ELSE
    -- Janna 17 Oct 2019 changed * to columns to show emailid as hidden for Demo account
    SELECT TOP 15
      Id,
      Gender,
      FirstName,
      LastName,
      Username,
      Name,
      Designation,
      Organization,
      Revenue,
      EmployeeCount,
      Functionality,
      industryName,
      '**********' EmailId,
      --EmailVerificationStatus,
      Country,
      Url,
      --LeadScore,
      MarketingListName,
      senioritylevel
    FROM #temp1
    --ORDER BY LeadScore DESC
END
