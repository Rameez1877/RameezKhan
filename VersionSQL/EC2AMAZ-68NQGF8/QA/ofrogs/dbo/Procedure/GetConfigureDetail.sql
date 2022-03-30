/****** Object:  Procedure [dbo].[GetConfigureDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetConfigureDetail] @userId int

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;


  CREATE TABLE #TempCountry (
    FilterType varchar(20),
    DataValues varchar(500),
  )

  CREATE TABLE #TempFunctionality (
     FilterType varchar(20),
    DataValues varchar(500),
  )

  CREATE TABLE #TempTechnology (
     FilterType varchar(20),
    DataValues varchar(500),
  )
  CREATE TABLE #TempSeniority (
     FilterType varchar(20),
    DataValues varchar(500),
  )
 -- Country
  INSERT INTO #TempCountry
    SELECT
      'Country' FilterType,
      c.name as CountryName
    FROM UserTargetCountry UTC, Country C
	where c.id = UTC.countryID
    and UTC.UserId = @userId
    GROUP BY  c.name
 
-- Functionality
  INSERT INTO #TempFunctionality
    SELECT 
      'Functionality' FilterType,
      Functionality
    FROM UserTargetFunctionality
    WHERE UserId = @userId
    GROUP BY Functionality
	
-- Technology
  INSERT INTO #TempTechnology
    SELECT TOP 10
      'Technology' FilterType,
      Technology
    FROM UserTargetTechnology
    WHERE UserId = @userId
    GROUP BY Technology

	-- Seniority
  INSERT INTO #TempSeniority
    SELECT 
      'SeniorityLevel' FilterType,
      Seniority
    FROM UserTargetSeniority
    WHERE UserId = @userId
    GROUP BY Seniority

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
  FROM #TempTechnology
  UNION ALL
  SELECT
  *
  FROM
  #TempSeniority

  DROP TABLE #TempCountry
  DROP TABLE #TempFunctionality
  DROP TABLE #TempTechnology
  DROP TABLE #TempSeniority
END
