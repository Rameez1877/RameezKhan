/****** Object:  View [dbo].[textrazoroutput]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.textrazoroutput
AS
SELECT        a.Id AS industryid, a.Name AS industryname, e.Name AS labelname, dbo.CategoryScore.Id AS categoryid, dbo.CategoryScore.RssFeedItemId, dbo.CategoryScore.Score, dbo.Tag.Name AS tagname, 
                         dbo.Tag.TagTypeID AS tagtype, dbo.RssFeedItem.Title, dbo.RssFeedItem.Link, dbo.RssFeedItem.PubDate
FROM            dbo.Industry AS a INNER JOIN
                         dbo.Category AS b ON a.Id = b.IndustryId INNER JOIN
                         dbo.Label AS e ON b.LabelId = e.Id INNER JOIN
                         dbo.LabelConceptWord AS c ON e.Id = c.LabelId INNER JOIN
                         dbo.CategoryScore ON b.Id = dbo.CategoryScore.CategoryId INNER JOIN
                         dbo.RssFeedItemTag ON dbo.CategoryScore.RssFeedItemId = dbo.RssFeedItemTag.RssFeedItemId INNER JOIN
                         dbo.Tag ON dbo.RssFeedItemTag.TagId = dbo.Tag.Id INNER JOIN
                         dbo.RssFeedItem ON dbo.CategoryScore.RssFeedItemId = dbo.RssFeedItem.Id
