/****** Object:  Procedure [dbo].[GetTargetAccountIntentDetailsCopy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetTargetAccountIntentDetailsCopy]
	@TargetPersonaId int
AS
/*
[dbo].[GetTargetAccountIntentDetailsCopy] 29815
select *from targetpersona where name like '%devop%'
*/
BEGIN
 
  Declare @UserId int, 
		  @RowsInserted int,
		  @Functionality varchar(max) = '',
		  @PersonaTypeIds varchar(500) = ''

  DECLARE @TargetPersonaId1 int = @TargetPersonaId


 Select @UserId = CreatedBy From TargetPersona where id = @TargetPersonaId1
 Select @PersonaTypeIds = PersonaIds From Appuser where id = @UserId
 Select Functionality into #functionalities from AdoptionFramework 
	where PersonaTypeId in (select value from string_split(@PersonaTypeIds, ','))

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

   
   -- Calculate TechnologySpend based on EmployeeCount
select distinct t.organizationid, 
Case
	when e.basecost < 300 then 'Extreme Low'
	when e.basecost >= 300 and e.basecost < 1000 then 'Very Low'
	when e.basecost >= 1000 and e.basecost < 10000 then 'Low'
	when e.basecost >= 10000 and e.basecost < 50000 then 'Average'
	when e.basecost >= 50000 and e.basecost < 100000 then 'High'
	when e.basecost >= 100000 and e.basecost < 300000 then 'Very High'
	when e.basecost >= 300000 then 'Extreme High'
End as BaseCost into #empbasecost
from TargetPersonaOrganization t 
Inner Join Organization o on (t.OrganizationId = o.Id)
Left Join EmployeeCountTechBaseCost e  on (e.EmployeeCount = o.EmployeeCount) 
where t.TargetPersonaId = @TargetPersonaId1


SELECT Distinct
  s.Organization,
  s.OrganizationId,
  s.Industry,
  s.Functionality,
  s.Technology,
  s.TechnologyCategory,
  s.InvestmentType,
  s.Revenue,
  s.CountryName, s.SpendEstimate 
  into #tempsurgesummary
FROM SurgeSummary s with (nolock)
	 Inner Join TargetPersonaOrganization t with (nolock) 
	 ON (s.organizationid = t.organizationid AND t.TargetPersonaId = @TargetPersonaId1)
WHERE s.CountryId IN (Select CountryId from TargetPersonaCountry WHERE TargetPersonaId = @TargetPersonaId1)
AND s.Functionality IN (Select distinct Functionality from #functionalities)
AND s.Technology IN (Select technologyName from TargetPersonaTechnologyName WHERE TargetPersonaId = @TargetPersonaId1)
--and organizationid in(select organizationid from TargetPersonaOrganization where TargetPersonaId = @targetPersonaId)

 SELECT Distinct
    o.id OrganizationID,
	tp.name as TargetPersonaName,
    O.[Name],
	case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
	T.Comment,
	S.Functionality,
	S.Technology,
	S.TechnologyCategory,
	S.InvestmentType,
	Case when T.OrganizationId in (Select OrganizationId from #tempsurgesummary) and S.SpendEstimate is not null then S.SpendEstimate 
	else ebc.BaseCost
	End as SpendEstimate,
	T.LeadScore
	into #TempChartDetail
    FROM TargetPersonaOrganization T 
    inner join organization o
    on (t.organizationid = o.id)
	left outer join #empbasecost ebc
	on (ebc.OrganizationId = T.OrganizationId)
    left outer join #tempsurgesummary S
    on (t.organizationId = s.organizationId --and S.spendestimate is not null
	)
    inner join Country c
    on (o.CountryId = c.ID)
    inner join Industry i
    on (o.IndustryId = i.id)
    inner join Targetpersona tp
    on (tp.id = t.TargetPersonaId  and T.TargetPersonaId = @TargetPersonaId1) 

	--select *from #TempChartDetail

 select Distinct OrganizationId,TargetPersonaName,Name,WebsiteUrl,CountryName,
 IndustryName,Employeecount,Revenue,comment,Functionality,
   Technology,
   CASE WHEN TechnologyCategory is NULL then 'NA' ELSE TechnologyCategory
   END AS TechnologyCategory,
    REPLACE(REPLACE(STUFF(
	(SELECT ', ' + t2.InvestmentType 
	from (select Distinct t1.Investmenttype from #TempChartDetail t1 where t1.OrganizationID = t.organizationid) t2
    FOR XML PATH (''))
	, 1, 1, ''), '&amp;', '&'), '''', '') As InvestmentType, Spendestimate, LeadScore
 from #TempChartDetail t
 where Technology is not null
 order by LeadScore desc, CountryName --,IndustryName,Revenue,Employeecount
	
	
	-- graph detail

	 CREATE TABLE #TempCountryList (
    CountryName varchar(100)
  )
  INSERT INTO #TempCountryList
    SELECT
      c.name
    FROM ConfiguredCountry UTC WITH (NOLOCK),
         Country C
    WHERE UTC.TargetPersonaId = @TargetPersonaId1
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
	where TargetPersonaId = @TargetPersonaId1

	 INSERT INTO TargetAccountIntentGraph
	  (TargetPersonaId,
  FilterType,
  DataString1,
  DataCount,
  OrderNumber)
    SELECT
      @TargetPersonaId1,
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


	DROP table #TempCountry
	drop table #TempIndustry
	drop table #TempCountryList
	drop table #TempRevenue
	drop table #TempSurgeSummary
	drop table #TempTechnology
	drop table #TempInvestmentType
	drop table #TempChartDetail
END 
