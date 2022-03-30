/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList1] @MarketingListId int, @UserId int
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      

BEGIN
  DECLARE @AppRoleID int
  DECLARE @locations varchar(4000),
          @functionality varchar(4000),
          @seniority varchar(4000)
  DECLARE @delimiter varchar(1) = ','
  DECLARE @InputParameter nvarchar(max)
  DECLARE @xml AS xml
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
  create table #Country(
  CountryName VARCHAR(200))
  create table #functionality(value varchar(500))
create table #seniority(value varchar(500))


  IF LEN(@locations) > 0
  BEGIN
    SET @InputParameter = @Locations

    Set @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
	insert into #Country
    SELECT
      C.value('.', 'varchar(2000)') AS [value] 
    FROM @xml.nodes('X') AS X (C)
   
  END

  IF LEN(@functionality) > 0
  BEGIN
    SET @InputParameter = @functionality

    Set @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
    insert into #functionality
	SELECT
      C.value('.', 'varchar(2000)') AS [value] 
    FROM @xml.nodes('X') AS X (C)
    
  END
    IF LEN(@seniority) > 0
  BEGIN
    SET @InputParameter = @seniority

    Set @XML = CAST(('<X>' + REPLACE(@InputParameter, @delimiter, '</X><X>') + '</X>') AS xml)
	insert into  #seniority
    SELECT
      C.value('.', 'varchar(2000)') AS [value] 
    FROM @xml.nodes('X') AS X (C)
    
  END

  IF @AppRoleID <> 3
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
      v.FunctionalityDisplay AS [Functionality],
      i.name AS industryName,
      li.EmailId,
      li.EmailVerificationStatus,
      RTRIM(li.ResultantCountry) AS Country,
      li.[Url],
      ls.TotalScore LeadScore,
      ml.MarketingListName,
      li.senioritylevel INTO #Temp1
    FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.MarketingLists ml
      ON (ml.id = @MarketingListId)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
    INNER JOIN dbo.Industry i
      ON (o.industryid = i.Id)
    INNER JOIN dbo.McDecisionMakerList mc
      ON (li.Id = mc.DecisionMakerId)
    INNER JOIN dbo.V_Functionality v
      ON (v.Functionality = mc.[Name])
    LEFT OUTER JOIN leadscore ls
      ON (ls.userid = 1
      AND ls.organizationid = o.id
      AND ls.type = 'Non App')
    WHERE li.id IN (SELECT
      DecisionMakerId
    FROM DecisionMakersForMarketingList
    WHERE MarketingListId = @MarketingListId)
    AND RTRIM(li.ResultantCountry) <> ''
	
	If len(@locations) >0 
	delete from #temp1 where Country not in (select countryname from #Country)
	
	If len(@functionality) >0 
	delete from #temp1 where functionality not in (select value from #functionality)
	
	If len(@Seniority) >0 
	delete from #temp1 where SeniorityLevel not in (select value from #Seniority)
	
  select * from #temp1
END
