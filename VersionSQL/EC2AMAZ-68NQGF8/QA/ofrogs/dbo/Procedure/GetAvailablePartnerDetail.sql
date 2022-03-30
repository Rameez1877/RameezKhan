/****** Object:  Procedure [dbo].[GetAvailablePartnerDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAvailablePartnerDetail]

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;


  CREATE TABLE #TempProduct (
     FilterType varchar(20),
	DataValues varchar(200),
	Id int
  )

  CREATE TABLE #TempSolution (
     FilterType varchar(20),
	DataValues varchar(200),
	Id int
  )

   CREATE TABLE #TempTeams (
     FilterType varchar(20),
	DataValues varchar(200),
	Id int default 1
  )
-- product
  INSERT INTO #TempProduct
    SELECT 
      'Product' FilterType,
       Product,
	   Id
    FROM V_Products
    GROUP BY Product,Id
	
-- Solution
  INSERT INTO #TempSolution
    SELECT 
      'Solution' FilterType,
      Product,
	  Id
    FROM V_Solutions
    GROUP BY Product,Id

	-- Teams
  INSERT INTO #TempTeams
    SELECT 
      'Teams' FilterType,
      SubMarketingListNameDisplay,
	  1
    FROM V_MarketingList
    GROUP BY SubMarketingListNameDisplay

  SELECT
    *
  FROM #TempProduct
  UNION ALL
  SELECT
    *
  FROM #TempSolution

  UNION ALL
  SELECT
    *
  FROM #TempTeams

  DROP TABLE #TempProduct
  DROP TABLE #TempSolution
  DROP TABLE #TempTeams

END
