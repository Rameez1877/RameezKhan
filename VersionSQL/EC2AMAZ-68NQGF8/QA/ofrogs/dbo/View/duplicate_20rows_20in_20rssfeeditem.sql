/****** Object:  View [dbo].[duplicate rows in rssfeeditem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.[duplicate rows in rssfeeditem]
AS
SELECT        Id
FROM            dbo.RssFeedItem
WHERE        (Title IN
                             (SELECT        Title
                               FROM            dbo.RssFeedItem AS RssFeedItem_1
                               WHERE        (YEAR(PubDate) = 2016) AND (Title IS NOT NULL)
                               GROUP BY Title
                               HAVING         (COUNT(*) > 1)))
