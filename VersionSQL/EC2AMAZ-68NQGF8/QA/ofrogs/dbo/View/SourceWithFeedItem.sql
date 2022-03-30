/****** Object:  View [dbo].[SourceWithFeedItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.SourceWithFeedItem
AS
SELECT        dbo.RssFeed.Id, dbo.RssFeed.Title, dbo.RssFeed.Link, dbo.RssFeed.PubDate, dbo.RssFeed.IsActive, dbo.RssSource.IndustryId, dbo.RssFeedItem.News, dbo.RssFeedItem.Link AS Expr1, dbo.RssSource.Name
FROM            dbo.RssSource INNER JOIN
                         dbo.RssFeed ON dbo.RssSource.Id = dbo.RssFeed.RssSourceId INNER JOIN
                         dbo.RssFeedItem ON dbo.RssFeed.Id = dbo.RssFeedItem.RssFeedId
