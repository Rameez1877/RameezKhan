/****** Object:  View [dbo].[TagWithIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.TagWithIndustry
AS
SELECT        dbo.IndustryTag.IndustryId, dbo.IndustryTag.TagId, dbo.Tag.Name, dbo.Industry.Name AS Expr1, dbo.Industry.IsActive
FROM            dbo.Industry INNER JOIN
                         dbo.IndustryTag ON dbo.Industry.Id = dbo.IndustryTag.IndustryId INNER JOIN
                         dbo.Tag ON dbo.IndustryTag.TagId = dbo.Tag.Id
