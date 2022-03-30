/****** Object:  Procedure [dbo].[GetPartnerConfiguredDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPartnerConfiguredDetail] @userId int

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;


  CREATE TABLE #TempCountry (
    FilterType varchar(20),
    DataValues varchar(500)
  )

  CREATE TABLE #TempFunctionality (
     FilterType varchar(20),
    DataValues varchar(500)
  )

  CREATE TABLE #TempProduct (
     FilterType varchar(20),
    DataValues varchar(500)
  )
   CREATE TABLE #TempSolution (
     FilterType varchar(20),
    DataValues varchar(500)
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
      'Teams' FilterType,
      Functionality
    FROM UserTargetFunctionality
    WHERE UserId = @userId
    GROUP BY Functionality
	
-- #TempProduct
  INSERT INTO #TempProduct
  SELECT
      'Product' FilterType,
       p.Product
    FROM V_Products p, UserTargetWebsiteProductGroup u
    WHERE p.id = u.websiteProductGroupID
	AND u.UserId = @userId
    GROUP BY p.Product

	-- #TempSolution
  INSERT INTO #TempSolution
  SELECT
      'Solution' FilterType,
      s.Product
    FROM V_Solutions s, UserTargetWebsiteSolutionGroup u
    WHERE s.id = u.websiteSolutionGroupID
	AND u.UserId = @userId
    GROUP BY s.Product

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
  FROM #TempProduct

   UNION ALL
  SELECT
    *
  FROM #TempSolution


  DROP TABLE #TempCountry
  DROP TABLE #TempFunctionality
  DROP TABLE #TempProduct
  DROP TABLE #TempSolution


END
