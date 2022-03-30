/****** Object:  Procedure [dbo].[GetMyCustomerGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMyCustomerGraph] @userId int

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;


  CREATE TABLE #TempCountry (
    FilterType varchar(20),
    DataString varchar(500),
	DataValues int
	
  )

  CREATE TABLE #TempIndustry (
     FilterType varchar(20),
     DataString varchar(500),
	DataValues int
  )

  CREATE TABLE #TempRevenue (
     FilterType varchar(20),
     DataString varchar(500),
	 DataValues int
  )
    CREATE TABLE #TempEmpCount (
     FilterType varchar(20),
     DataString varchar(500),
	 DataValues int
  )
 -- Country
  INSERT INTO #TempCountry
    SELECT
      'Country' FilterType,
      c.name as CountryName,
	  count(*)
    FROM organizationchampion o, Country C
	where c.id = o.countryId
    and o.UserId = @userId
    GROUP BY  c.name
	
 
-- Industry
  INSERT INTO #TempIndustry
    SELECT 
      'Industry' FilterType,
      i.name as Industry,
	  COUNT(*)
    FROM organizationchampion o, Industry i, Organization org
	where i.Id = org.IndustryId
	and o.organizationId = org.id
    and o.UserId = @userId
    GROUP BY i.Name
	
-- Revenue
  INSERT INTO #TempRevenue
    SELECT
      'Revenue' FilterType,
      org.Revenue,
	  Count(*)
    FROM organizationchampion o, Organization org
	where o.OrganizationId = org.id
    and o.UserId = @userId
    GROUP BY Revenue

	-- EmpCount
  INSERT INTO #TempEmpCount
    SELECT
      'EmpCount' FilterType,
      org.EmployeeCount,
	  COUNT(*)
    FROM organizationchampion o, Organization org
	where o.OrganizationId = org.id
    and o.UserId = @userId
    GROUP BY EmployeeCount

  SELECT
    *
  FROM #TempCountry
  UNION ALL
  SELECT
    *
  FROM #TempIndustry
  UNION ALL
  SELECT
    *
  FROM #TempRevenue
  UNION ALL
  SELECT
    *
  FROM #TempEmpCount

  DROP TABLE #TempCountry
  DROP TABLE #TempIndustry
  DROP TABLE #TempRevenue
  DROP TABLE #TempEmpCount

END
