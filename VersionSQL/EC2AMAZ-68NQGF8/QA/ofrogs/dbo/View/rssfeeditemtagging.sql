/****** Object:  View [dbo].[rssfeeditemtagging]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.View_2
AS
SELECT        b.Title, b.PubDate, b.Description, d.Name
FROM            dbo.RssFeedItemIndustry AS c INNER JOIN
                         dbo.RssFeedItem AS b ON c.RssFeedItemId = b.Id INNER JOIN
                         dbo.RssFeedItemTag AS a ON c.RssFeedItemId = a.RssFeedItemId AND b.Id = a.RssFeedItemId INNER JOIN
                         dbo.Tag AS d ON a.TagId = d.Id
WHERE        (b.IsActive = 1) AND (b.ValidationDate IS NOT NULL)
