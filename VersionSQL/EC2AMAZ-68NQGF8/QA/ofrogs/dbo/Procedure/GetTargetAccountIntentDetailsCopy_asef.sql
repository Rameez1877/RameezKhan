/****** Object:  Procedure [dbo].[GetTargetAccountIntentDetailsCopy_asef]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetTargetAccountIntentDetailsCopy_asef]
@TargetPersonaId int
AS
BEGIN
 
  Declare @UserId int, 
		  @RowsInserted int

 Select @UserId = CreatedBy From TargetPersona where id = @targetPersonaId

   CREATE TABLE #TempCountry (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int
  )
  CREATE TABLE #TempIndustry (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int
  )
  CREATE TABLE #TempRevenue (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int
  )
  CREATE TABLE #TempTechnology (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int
   )
    CREATE TABLE #TempInvestmentType (
    FilterType varchar(50),
    DataString1 varchar(500),
    DataCount int,
    OrderNumber int
   )


SELECT Distinct
  Organization,
  OrganizationId,
  Industry,
  Functionality,
  Technology,
  TechnologyCategory,
  InvestmentType,
  Revenue,
  CountryName into #tempsurgesummary
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
AND Technology IN (Select technology from UserTargetTechnology WHERE UserId = @UserId union select 'NA' )
and organizationid in(select organizationid from TargetPersonaOrganization where TargetPersonaId = @targetPersonaId)
 
 SELECT Distinct
    o.id OrganizationID,
	tp.name as TargetPersonaName,
    O.Name,
	case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
	T.Comment,
	S.Functionality,
	S.Technology,
	S.TechnologyCategory,
	S.InvestmentType
	into #TempChartDetail
    FROM TargetPersonaOrganization T 
    inner join organization o
    on (t.organizationid = o.id)
    left outer join #tempsurgesummary S
    on (t.organizationId = s.organizationId)
    inner join Country c
    on (o.CountryId = c.ID)
    inner join Industry i
    on (o.IndustryId = i.id)
    inner join Targetpersona tp
    on (tp.id = t.TargetPersonaId  and T.TargetPersonaId = @TargetPersonaId) 

	select *from #TempChartDetail
	-- graph detail

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
	  ;
	   WITH cte
  AS (SELECT TOP 10
    ct.countryname DataString1,
    COUNT(*) DataCount
  FROM #TempChartDetail ct,
       Organization O WITH (NOLOCK),
       #TempCountryList tc
  WHERE ct.OrganizationId = o.id
  AND ct.countryname = tc.countryname
  GROUP BY ct.countryname
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


	  -- 1)b) Populate Revenue Analysis
  
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
    FROM #TempChartDetail
    WHERE revenue <> 'Unknown'
    GROUP BY Revenue
  

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
      ct.IndustryName DataString1,
      COUNT(*) AS DataCount
    FROM #TempChartDetail ct
    WHERE ct.IndustryName <> 'Unknown'
    GROUP BY ct.IndustryName
    ORDER BY COUNT(*) DESC) a
  --
  -- 1)d) Populate Technology Analysis
  --
  INSERT INTO #TempTechnology (FilterType,
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
      ct.Technology DataString1,
      COUNT(*) AS DataCount
    FROM #TempChartDetail ct
    WHERE ct.Technology <> 'NA'
    GROUP BY ct.Technology
    ORDER BY COUNT(*) DESC) a


	--investment type

	INSERT INTO #TempInvestmentType (FilterType,
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
      ct.InvestmentType DataString1,
      ROUND(CAST(COUNT(*) AS float) / CAST(SUM(COUNT(*)) OVER () AS float) * 100, 0) AS DataCount
    FROM #TempChartDetail ct
    GROUP BY ct.InvestmentType) a

	delete from TargetAccountIntentGraph
	where TargetPersonaId = @TargetPersonaId

	 INSERT INTO TargetAccountIntentGraph
	  (TargetPersonaId,
  FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      @TargetPersonaId,
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM (SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM #TempCountry
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM #TempRevenue
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM #TempIndustry
	 UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM #TempInvestmentType
    UNION ALL
    SELECT
      FilterType,
      DataString1,
      DataCount,
      OrderNumber
    FROM #TempTechnology) b


	--DROP table #TempCountry
	--drop table #TempIndustry
	--drop table #TempCountryList
	--drop table #TempRevenue
	--drop table #TempSurgeSummary
	--drop table #TempTechnology
	--drop table #TempInvestmentType
	--drop table #TempChartDetail
END 

--select *from TargetAccountIntentGraph

--select *from targetpersona where createdby = 300
--exec [GetTargetAccountIntentDetailsCopy_asef] 15719
