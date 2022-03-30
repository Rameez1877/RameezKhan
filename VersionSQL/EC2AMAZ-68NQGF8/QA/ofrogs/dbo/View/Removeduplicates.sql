/****** Object:  View [dbo].[Removeduplicates]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Removeduplicates]
AS
WITH CTE AS
(
SELECT rssfeeditem.id, rssfeeditem.Title, ROW_NUMBER() OVER (PARTITION BY rssfeeditem.Title ORDER BY rssfeeditem.id) AS RN
FROM rssfeeditem
INNER JOIN rssfeed on rssfeed.Id = rssfeeditem.RssFeedId
INNER JOIN rsssource on rsssource.id = rssfeed.RssSourceId and rsssource.IndustryId = 36 and RssSource.rssTypeId = 1
)
select * FROM CTE WHERE RN>1
