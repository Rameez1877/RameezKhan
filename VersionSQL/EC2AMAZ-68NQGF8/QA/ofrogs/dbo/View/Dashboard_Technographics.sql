/****** Object:  View [dbo].[Dashboard_Technographics]    Committed by VersionSQL https://www.versionsql.com ******/

Create view  [dbo].[Dashboard_Technographics]
as
WITH cte
AS (SELECT
  Keyword,
  CONVERT(varchar, MAX(inserteddate), 23) LastRunDate
FROM Technographics

GROUP BY Keyword)

SELECT
  t.Keyword,
  t2.StackType,
  COUNT(*) as NoOfrecords,
  cte.LastRunDate
FROM Technographics t
JOIN TechStackTechnology t1
  ON t.tagid = t1.TagId
JOIN TechStackSubCategory t2
  ON t2.id = t1.StackSubCategoryId
JOIN cte
  ON cte.keyword = t.keyword

GROUP BY t.Keyword,
         t2.StackType,
         cte.LastRunDate
