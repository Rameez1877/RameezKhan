/****** Object:  Procedure [dbo].[PopulateSurgeDashboardPerUserID_anurag]    Committed by VersionSQL https://www.versionsql.com ******/

-- ============================================================================================================
-- Author        : Janna
-- Create date     : 27th Dec 2019
-- Description	 : Populate Opportunity Finder Dashboard For a User (Surge Dahboard)
-- Called by PopulateSurgeDashboard
-- For graphical reports we use Surge data of 6 months
-- i.e. Country,Revenue,Industry,Technology and Investment Type
-- For non graphical reports we use Surge data of 2 months
-- i.e. We compare data of last 2 months and report against them
-- ============================================================================================================

CREATE PROCEDURE [dbo].[PopulateSurgeDashboardPerUserID_anurag] @UserID int
AS
/*
PopulateSurgeDashboardPerUserID_anurag 315
*/
BEGIN
  SET ANSI_WARNINGS OFF;
  SET NOCOUNT ON;
  DECLARE @RowsInserted int

  CREATE TABLE #TempCountry (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int,
    DataString2 varchar(500)
  )
  CREATE TABLE #TempIndustry (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int,
    DataString2 varchar(500)
  )
  CREATE TABLE #TempRevenue (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int,
    DataString2 varchar(500)
  )
  CREATE TABLE #TempTechnology (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int,
    DataString2 varchar(500)
  )
  CREATE TABLE #TempMonthlyOpportunty (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int,
    DataString2 varchar(500)
  )
  CREATE TABLE #TempSurgeSummary (
    ID int,
    OrganizationId int NULL,
    Organization varchar(500) NULL,
    IndustryID int NULL,
    Industry varchar(500) NULL,
    Functionality varchar(100) NULL,
    Technology varchar(100) NULL,
    InvestmentType varchar(30) NULL,
    CountryID int NULL,
    CountryName varchar(100) NOT NULL,
    Duration int NULL,
    Surge int NULL,
    NoOfDecisionMaker int NULL,
    Revenue varchar(20) NULL,
    EmployeeCount varchar(20) NULL,
    TechnologyCategory varchar(100) NULL
  )

  CREATE TABLE #TempOpportunitiesThisWeek (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount decimal(10, 2),
    OrderNumber int,
    DataString2 varchar(500)
  )
  DECLARE @TechnologyCount int
  SELECT
    @TechnologyCount = COUNT(*)
  FROM UserTargetTechnology with (nolock)
  WHERE userId = @Userid

  IF @TechnologyCount = 0

    INSERT INTO #TempSurgeSummary
      SELECT
        *
      FROM surgesummary WITH (NOLOCK)
      WHERE countryid IN (SELECT
        countryid
      FROM usertargetcountry WITH (NOLOCK)
      WHERE userid = @UserID)
      AND functionality IN (SELECT
        functionality
      FROM usertargetfunctionality WITH (NOLOCK)
      WHERE userid = @UserID)

  ELSE
    INSERT INTO #TempSurgeSummary
      SELECT
        *
      FROM surgesummary WITH (NOLOCK)
      WHERE countryid IN (SELECT
        countryid
      FROM usertargetcountry WITH (NOLOCK)
      WHERE userid = @UserID)
      AND functionality IN (SELECT
        functionality
      FROM usertargetfunctionality WITH (NOLOCK)
      WHERE userid = @UserID)
      AND Technology IN (SELECT
        technology
      FROM usertargetTechnology WITH (NOLOCK)
      WHERE userid = @UserID
      UNION
      SELECT
        'NA' AS technology)

  --
  -- Section 1)	Quantitative Analysis
  --
  -- 1)a) Populate Country Analysis
  --
  -- Country List Either From SetUp If present Else from The Country Table Starts
  --
  CREATE TABLE #TempCountryList (
    CountryName varchar(100)
  )
  INSERT INTO #TempCountryList
    SELECT
      c.name
    FROM UserTargetCountry UTC WITH (NOLOCK),
         Country C
    WHERE UTC.UserId = @UserID
    AND UTC.CountryID = C.ID

  SET @RowsInserted = @@Rowcount
  IF @RowsInserted = 0
    INSERT INTO #TempCountryList
      SELECT
        c.name
      FROM Country C WITH (NOLOCK)
    --
    -- Country List Either From SetUp If present Else from The Country Table Ends
    --
    ;
  WITH cte
  AS (SELECT TOP 10
    ss.countryname DataString1,
    COUNT(*) DataCount
  FROM #TempSurgeSummary SS,
       Organization O WITH (NOLOCK),
       #TempCountryList tc
  WHERE ss.OrganizationId = o.id
  AND ss.countryname = tc.countryname
  GROUP BY ss.countryname
  ORDER BY COUNT(*) DESC)
  INSERT INTO #TempCountry (FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      'Country' AS FilterType,
      DataString1,
      ROUND(CAST(DataCount AS float) / CAST(SUM(DataCount) OVER () AS float) * 100, 0) AS DataCount,
      NULL
    FROM cte
  --
  -- 1)b) Populate Revenue Analysis
  --
  INSERT INTO #TempRevenue (FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      'Revenue' FilterType,
      Revenue,
      ROUND(CAST(COUNT(*) AS float) / CAST(SUM(COUNT(*)) OVER () AS float) * 100, 0) AS DataCount,
      CASE
        WHEN revenue = '<1M' THEN 1
        WHEN revenue = '1M-10M' THEN 2
        WHEN revenue = '10M-50M' THEN 3
        WHEN revenue = '50M-100M' THEN 4
        WHEN revenue = '100M-250M' THEN 5
        WHEN revenue = '250M-500M' THEN 6
        WHEN revenue = '500M-1B' THEN 7
        WHEN revenue = '>1B' THEN 8
        WHEN revenue = 'Unknown' THEN 9
      END AS OrderNumber
    FROM #TempSurgeSummary
    WHERE revenue <> 'Unknown'
    GROUP BY Revenue
  --
  -- 1)c) Populate Industry Analysis
  --
  INSERT INTO #TempIndustry (FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      FilterType,
      DataString1,
      ROUND(CAST(DataCount AS float) / CAST(SUM(DataCount) OVER () AS float) * 100, 0) DataCount,
      ROW_NUMBER() OVER (ORDER BY DataCount DESC) OrderNumber
    FROM (SELECT TOP 10
      'Industry' AS FilterType,
      ss.Industry DataString1,
      COUNT(*) AS DataCount
    FROM #TempSurgeSummary SS
    WHERE ss.Industry <> 'Unknown'
    GROUP BY ss.Industry
    ORDER BY COUNT(*) DESC) a
  --
  -- 1)d) Populate Technology Analysis
  --
  INSERT INTO #TempIndustry (FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      FilterType,
      DataString1,
      ROUND(CAST(DataCount AS float) / CAST(SUM(DataCount) OVER () AS float) * 100, 0) DataCount,
      ROW_NUMBER() OVER (ORDER BY DataCount DESC) OrderNumber
    FROM (SELECT TOP 10
      'Technology' AS FilterType,
      ss.Technology DataString1,
      COUNT(*) AS DataCount
    FROM #TempSurgeSummary SS
    WHERE ss.Technology <> 'NA'
    GROUP BY ss.Technology
    ORDER BY COUNT(*) DESC) a

  --
  -- 1)e) Populate Investment Type Analysis
  --
  INSERT INTO #TempIndustry (FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      FilterType,
      DataString1,
      DataCount,
      ROW_NUMBER() OVER (ORDER BY DataCount DESC) OrderNumber
    FROM (SELECT
      'Investment Type' AS FilterType,
      ss.InvestmentType DataString1,
      ROUND(CAST(COUNT(*) AS float) / CAST(SUM(COUNT(*)) OVER () AS float) * 100, 0) AS DataCount
    FROM #TempSurgeSummary SS
    GROUP BY ss.InvestmentType) a

  --
  -- 1)f) Monthly Opportunities
  --
  --INSERT INTO #TempMonthlyOpportunty (FilterType,
  --DataString1,
  --DataCount,
  --OrderNumber,
  --DataString2)
  --  SELECT
  --    'Monthly Opportunities' FilterType,
  --    InvestmentType DataString1,
  --    COUNT(*) DataCount,
  --    duration AS OrderNumber,
  --    (CASE
  --      WHEN duration = 1 THEN FORMAT(GETDATE(), 'MMM')
  --      WHEN duration = 2 THEN FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMM')
  --      WHEN duration = 3 THEN FORMAT(DATEADD(MONTH, -2, GETDATE()), 'MMM')
  --      WHEN duration = 4 THEN FORMAT(DATEADD(MONTH, -3, GETDATE()), 'MMM')
  --      WHEN duration = 5 THEN FORMAT(DATEADD(MONTH, -4, GETDATE()), 'MMM')
  --      WHEN duration = 6 THEN FORMAT(DATEADD(MONTH, -5, GETDATE()), 'MMM')
  --    END) DataString2
  --  FROM surgesummary
  --  GROUP BY investmenttype,
  --           duration

  --
  -- Surge Opportunities This/Last Week, Opportunities Via Technology This/Last Week and and Account Opportunities This/Last Week
  --

  DELETE FROM #TempSurgeSummary
  WHERE Duration NOT IN (1, 2)

  DECLARE @OpportunitiesMonth1 int,
          @OpportunitiesMonth2 int
  DECLARE @OpportunitiesTechMonth1 int,
          @OpportunitiesTechMonth2 int
  DECLARE @OpportunitiesOrgMonth1 int,
          @OpportunitiesOrgMonth2 int

  SELECT
    @OpportunitiesMonth1 = SUM(CASE
      WHEN Duration = 1 THEN 1
      ELSE 0
    END),
    @OpportunitiesMonth2 = SUM(CASE
      WHEN Duration = 2 THEN 1
      ELSE 0
    END),
    @OpportunitiesTechMonth1 = SUM(CASE
      WHEN Duration = 1 AND
        Technology <> 'NA' THEN 1
      ELSE 0
    END),
    @OpportunitiesTechMonth2 = SUM(CASE
      WHEN Duration = 2 AND
        Technology <> 'NA' THEN 1
      ELSE 0
    END),
    @OpportunitiesOrgMonth1 = COUNT(DISTINCT (CASE
      WHEN Duration = 1 THEN OrganizationID
    END)),
    @OpportunitiesOrgMonth2 = COUNT(DISTINCT (CASE
      WHEN Duration = 2 THEN OrganizationID
    END))
  FROM #TempSurgeSummary

  DECLARE @OpportunityThisMonth decimal(15, 2),
          @OpportunitiesTechMonth decimal(15, 2),
          @OpportunitiesOrgMonth decimal(15, 2)
  DECLARE @OpportunityThisMonthSign int,
          @OpportunitiesTechMonthSign int,
          @OpportunitiesOrgMonthSign int

  PRINT @OpportunitiesMonth1
  PRINT @OpportunitiesMonth2
  IF @OpportunitiesMonth2 <> 0
    SET @OpportunityThisMonth = ABS(CAST(@OpportunitiesMonth1 AS decimal) - CAST(@OpportunitiesMonth2 AS decimal)) /
    CAST(@OpportunitiesMonth2 AS decimal) * 100
  ELSE
    SET @OpportunityThisMonth = 0

  IF @OpportunitiesTechMonth2 <> 0
    SET @OpportunitiesTechMonth = ABS(CAST(@OpportunitiesTechMonth1 AS decimal) - CAST(@OpportunitiesTechMonth2 AS decimal)) /
    CAST(@OpportunitiesTechMonth2 AS decimal) * 100
  ELSE
    SET @OpportunitiesTechMonth = 0

  IF @OpportunitiesOrgMonth2 <> 0
    SET @OpportunitiesOrgMonth = ABS(CAST(@OpportunitiesOrgMonth1 AS decimal) - CAST(@OpportunitiesOrgMonth2 AS decimal)) /
    CAST(@OpportunitiesOrgMonth2 AS decimal) * 100
  ELSE
    SET @OpportunitiesOrgMonth = 0
  --
  -- Signs for 3 variables
  --
  IF @OpportunitiesMonth1 - @OpportunitiesMonth2 > 0
    SET @OpportunityThisMonthSign = +1
  ELSE
    SET @OpportunityThisMonthSign = -1

  IF @OpportunitiesTechMonth1 - @OpportunitiesTechMonth2 > 0
    SET @OpportunitiesTechMonthSign = +1
  ELSE
    SET @OpportunitiesTechMonthSign = -1

  IF @OpportunitiesOrgMonth1 - @OpportunitiesOrgMonth2 > 0
    SET @OpportunitiesOrgMonthSign = +1
  ELSE
    SET @OpportunitiesOrgMonthSign = -1

  INSERT INTO #TempOpportunitiesThisWeek (FilterType,
  DataString1,
  DataCount,
  DataString2)
    VALUES ('Opportunities This Month', @OpportunitiesMonth1, @OpportunityThisMonth, @OpportunityThisMonthSign)

  INSERT INTO #TempOpportunitiesThisWeek (FilterType,
  DataString1,
  DataCount,
  DataString2)
    VALUES ('Opportunities This Month Via Technology', @OpportunitiesTechMonth1, @OpportunitiesTechMonth, @OpportunitiesTechMonthSign)


  INSERT INTO #TempOpportunitiesThisWeek (FilterType,
  DataString1,
  DataCount,
  DataString2)
    VALUES ('Account Opportunities This Month', @OpportunitiesOrgMonth1, @OpportunitiesOrgMonth, @OpportunitiesOrgMonthSign)

  INSERT INTO #TempOpportunitiesThisWeek (FilterType,
  DataString1,
  DataCount,
  DataString2,
  OrderNumber)
    SELECT TOP 5
      'Top 5 Accounts' FilterType,
      Organization DataString1,
      SUM(Surge) DataCount,
      NULL DataString2,
      ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) OrderNumber
    FROM #TempSurgeSummary
    GROUP BY Organization
    ORDER BY COUNT(*) DESC

  INSERT INTO #TempOpportunitiesThisWeek (FilterType,
  DataString1,
  DataCount,
  DataString2,
  OrderNumber)
    SELECT TOP 5
      'Top 5 Strategic Intents' FilterType,
      Functionality DataString1,
      SUM(Surge) DataCount,
      NULL DataString2,
      ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) OrderNumber
    FROM #TempSurgeSummary
    GROUP BY Functionality
    ORDER BY COUNT(*) DESC
  --
  -- Final Result Query
  --
  DELETE SurgeDashBoard
  WHERE UserID = @UserID

  INSERT INTO SurgeDashBoard (UserId,
  FilterType,
  DataString1,
  DataCount,
  OrderNumber,
  DataString2)
    SELECT
      @UserID,
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM (SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM #TempCountry
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM #TempRevenue
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM #TempIndustry
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM #TempTechnology
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber,
      DataString2
    FROM #TempOpportunitiesThisWeek) a

	DROP table #TempCountry
	drop table #TempIndustry
	drop table #TempCountryList
	drop table #TempMonthlyOpportunty
	drop table #TempOpportunitiesThisWeek
	drop table #TempRevenue
	drop table #TempSurgeSummary
	drop table #TempTechnology
END
