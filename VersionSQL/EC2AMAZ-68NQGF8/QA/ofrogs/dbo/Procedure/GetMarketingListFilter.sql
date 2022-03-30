/****** Object:  Procedure [dbo].[GetMarketingListFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMarketingListFilter]
@targetPersonaId int,
@ResultantCountry varchar(8000) = '',
@Functionality varchar(8000) = '',
@Seniority varchar(8000) = ''
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  IF @ResultantCountry IS NULL
    SET @ResultantCountry = ''
  IF @ResultantCountry IS NULL
    SET @ResultantCountry = ''
  IF @Functionality IS NULL
    SET @Functionality = ''

  IF @Seniority IS NULL
    SET @Seniority = ''

  CREATE TABLE #TempCountry (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )

  CREATE TABLE #TempIndustry (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )

CREATE TABLE #TempRevenue (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )

    CREATE TABLE #TempEmployeeCount (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )

   IF @targetPersonaId NOT IN (select DISTINCT TargetPersonaID from MarketingListFilterCopy)
 begin
exec PopulateMarketingListFilterSummary @targetPersonaId
 end

  --Country
  INSERT INTO #TempCountry
    SELECT TOP 10
      'Country' FilterType,
      Location,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilterCopy with (nolock)
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Functionality IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
    AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
	GROUP BY Location
    ORDER BY SUM(NoOfRecords) DESC;
-- Functionality
  INSERT INTO #TempIndustry
    SELECT TOP 10
      'Industry' FilterType,
      Industry,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilterCopy with (nolock)
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Functionality IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
    AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
    GROUP BY Industry
	order by NoOfRecords desc;
-- Revenue
  INSERT INTO #TempRevenue
    SELECT TOP 10
      'Revenue' FilterType,
      Revenue,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilterCopy with (nolock)
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Functionality IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
    AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
    GROUP BY Revenue
	order by NoOfRecords desc;

	--EmployeeCount
	INSERT INTO #TempEmployeeCount
    SELECT TOP 10
      'EmployeeCount' FilterType,
      EmployeeCount,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilterCopy with (nolock)
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Functionality IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
    AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
    GROUP BY EmployeeCount
	order by NoOfRecords desc;

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
  FROM #TempEmployeeCount

  DROP TABLE #TempCountry
  DROP TABLE #TempIndustry
  DROP TABLE #TempRevenue
  DROP TABLE #TempEmployeeCount

END
