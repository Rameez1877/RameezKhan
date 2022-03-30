/****** Object:  View [dbo].[LabelScore]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.View_3
AS
SELECT        b.IndustryId AS industryid, f.Name AS tagname, d.Title, d.Description, d.Link, c.Name AS labelname, a.Score, d.PubDate
FROM            dbo.CategoryScore AS a INNER JOIN
                         dbo.Category AS b ON a.CategoryId = b.Id INNER JOIN
                         dbo.Label AS c ON b.LabelId = c.Id INNER JOIN
                         dbo.RssFeedItem AS d ON a.RssFeedItemId = d.Id INNER JOIN
                         dbo.RssFeedItemTag AS e ON a.RssFeedItemId = e.RssFeedItemId AND d.Id = e.RssFeedItemId INNER JOIN
                         dbo.Tag AS f ON e.TagId = f.Id
