/****** Object:  View [dbo].[V_MarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[V_MarketingList]
AS
WITH cte
AS (SELECT
  name,
  min(CAST(IsInternalList AS tinyint)) IsInternalList
FROM McDecisionmaker
WHERE isoflist = 1
AND isactive = 1
GROUP BY name)
SELECT DISTINCT
  Name AS SubMarketingListNameDisplay,
  Name AS SubMarketingListName
FROM cte
WHERE IsInternalList = 0
