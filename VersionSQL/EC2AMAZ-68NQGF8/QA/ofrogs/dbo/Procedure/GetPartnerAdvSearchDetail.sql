/****** Object:  Procedure [dbo].[GetPartnerAdvSearchDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPartnerAdvSearchDetail] @UserId int

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
-- product
-- 09-NOV-2021 - Kabir - Partner should have access to all Groups and Solutions
  INSERT INTO #TempProduct
    SELECT 
      'Product' FilterType,
       Product,
	   Id
    FROM V_Products
	--where product in (select b.name from UserTargetWebsiteProductGroup a, WebsiteIntentKeywordCategory b
--where a.WebsiteProductGroupID = b.ID 
--and a.UserID=@userID)
    GROUP BY Product,Id
	
-- Solution
  INSERT INTO #TempSolution
    SELECT 
      'Solution' FilterType,
      Product,
	  Id
    FROM V_Solutions
	--where product in (select b.name from UserTargetWebsiteSolutionGroup a, 
	--WebsiteIntentKeywordCategory b
--where a.WebsiteSolutionGroupID = b.ID 
--and a.UserID=@userID)
    GROUP BY Product,Id


  SELECT
    *
  FROM #TempProduct
  UNION ALL
  SELECT
    *
  FROM #TempSolution

  DROP TABLE #TempProduct
  DROP TABLE #TempSolution

END
