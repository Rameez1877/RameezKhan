/****** Object:  Procedure [dbo].[GetMarketingListFilterTemp2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[GetMarketingListFilterTemp2] @targetPersonaId int,
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

  CREATE TABLE #TempFunctionality (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )

  CREATE TABLE #TempSeniority (
    FilterType varchar(20),
    Location varchar(500),
    NoOfRecords int
  )
  --Country
  INSERT INTO #TempCountry
    SELECT TOP 10
      'Country' FilterType,
      Location,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilter
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Industry IN (SELECT
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
  INSERT INTO #TempFunctionality
    SELECT TOP 10
      'Functionality' FilterType,
      Industry,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilter
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Industry IN (SELECT
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
-- Seniority
  INSERT INTO #TempSeniority
    SELECT TOP 10
      'Seniority' FilterType,
      Seniority,
      SUM(NoOfRecords) NoOfRecords
    FROM MarketingListFilter
    WHERE TargetPersonaID = @targetPersonaId
    AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
    AND (@Functionality = ''
    OR Industry IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
    AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
    GROUP BY Seniority
	order by NoOfRecords desc;

  SELECT
    *
  FROM #TempCountry
  UNION ALL
  SELECT
    *
  FROM #TempFunctionality
  UNION ALL
  SELECT
    *
  FROM #TempSeniority

  DROP TABLE #TempCountry
  DROP TABLE #TempFunctionality
  DROP TABLE #TempSeniority

END
