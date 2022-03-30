/****** Object:  View [dbo].[daily charity news count]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.[daily charity news count]
AS
SELECT        DAY(b.PubDate) AS Expr1, COUNT(*) AS Expr2
FROM            dbo.RssSource AS a INNER JOIN
                         dbo.RssFeed AS c ON a.Id = c.RssSourceId INNER JOIN
                         dbo.RssFeedItem AS b ON c.Id = b.RssFeedId
WHERE        (YEAR(b.PubDate) = 2017) AND (MONTH(b.PubDate) = 5) AND (a.IndustryId = 36)
GROUP BY DAY(b.PubDate)
