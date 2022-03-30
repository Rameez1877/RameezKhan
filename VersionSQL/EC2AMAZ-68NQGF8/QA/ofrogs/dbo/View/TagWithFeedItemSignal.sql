/****** Object:  View [dbo].[TagWithFeedItemSignal]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.TagWithFeedItemSignal
AS
SELECT        dbo.RssFeedItem.Title, dbo.RssFeedItem.Link, dbo.RssFeedItem.News, dbo.Signal.Name, dbo.Signal.SignalWeight, dbo.RssFeedItemSignal.IndustryId, dbo.Tag.Name AS Company, dbo.Tag.TagTypeId
FROM            dbo.RssFeedItem INNER JOIN
                         dbo.RssFeedItemSignal ON dbo.RssFeedItem.Id = dbo.RssFeedItemSignal.RssFeedItemId INNER JOIN
                         dbo.Signal ON dbo.RssFeedItemSignal.SignalId = dbo.Signal.Id INNER JOIN
                         dbo.Tag ON dbo.RssFeedItemSignal.TagId = dbo.Tag.Id
