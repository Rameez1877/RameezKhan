/****** Object:  View [dbo].[OutputIndustrySignalAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[OutputIndustrySignalAnalysis]
AS
SELECT        CAST(ROW_NUMBER() OVER (ORDER BY rssfeeditemid) - 1 AS INT) AS id, NULL AS RegionName, NULL AS ContinentName, NULL AS CountryName, RFS.IndustryId, RF.Id AS RssfeedItemId, T .Id AS tagId, T .Name AS tagName, 
S.DisplayName, S.id AS SignalId, NULL AS SignalWord, CASE WHEN ISNULL(RF.PubDate, '2016-09-30') <= '2016-09-30 23:59:59' THEN '2016-Q3 or Before' ELSE CAST(year(RF.PubDate) AS char(4)) 
+ '-Q' + CAST(CEILING(CAST(month(RF.PubDate) AS decimal(4, 2)) / 3) AS char(1)) END AS newsQuarter, RF.Title, RF.Link, RF.description, RF.PubDate, RFS.ScoreDate, S.SignalType
FROM            dbo.RssFeedItemSignal AS RFS INNER JOIN
                         dbo.RssFeedItem AS RF ON RFS.RssFeedItemId = RF.Id INNER JOIN
                         dbo.Tag AS T ON RFS.TagId = T .Id AND T .TagTypeId = 1 INNER JOIN
                         dbo.Organization AS O ON O.Id = T .OrganizationId AND O.IsActive = 1 INNER JOIN
                         dbo.Industry AS I ON RFS.IndustryId = I.Id INNER JOIN
                         dbo.Signal AS S ON RFS.SignalId = S.Id INNER JOIN
                         dbo.IndustryTag ON T .Id = dbo.IndustryTag.TagId AND I.Id = dbo.IndustryTag.IndustryId
