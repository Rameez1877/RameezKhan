/****** Object:  Procedure [dbo].[TestAsef2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TestAsef2] @userId int

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;


  CREATE TABLE #TempCountry (
    FilterType varchar(20),
    DataValues varchar(500),
	Id int
  )

  CREATE TABLE #TempFunctionality (
     FilterType varchar(20),
    DataValues varchar(500),
	Id int
  )

 -- Country
  INSERT INTO #TempCountry
    SELECT
      'Country' FilterType,
      c.name as CountryName,
	  c.ID
    FROM UserTargetCountry UTC, Country C
	where c.id = UTC.countryID
    and UTC.UserId = @userId
    GROUP BY  c.name, c.id
 
-- Functionality
  INSERT INTO #TempFunctionality
    SELECT 
      'Functionality' FilterType,
      Functionality,
	  UserId
    FROM UserTargetFunctionality
    WHERE UserId = @userId
    GROUP BY Functionality,UserId
	
	



  SELECT
    *
  FROM #TempCountry
  UNION ALL
  SELECT
    *
  FROM #TempFunctionality

  DROP TABLE #TempCountry
  DROP TABLE #TempFunctionality
 

END
