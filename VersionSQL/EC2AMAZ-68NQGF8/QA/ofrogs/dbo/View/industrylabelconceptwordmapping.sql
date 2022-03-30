/****** Object:  View [dbo].[industrylabelconceptwordmapping]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.industrylabelconceptwordmapping
AS
SELECT        a.Name AS industryname, e.Name AS labelname, d.Name AS conceptword, b.Id AS categoryid, e.Id AS labelid
FROM            dbo.Industry AS a INNER JOIN
                         dbo.Category AS b ON a.Id = b.IndustryId INNER JOIN
                         dbo.Label AS e ON b.LabelId = e.Id INNER JOIN
                         dbo.LabelConceptWord AS c ON e.Id = c.LabelId INNER JOIN
                         dbo.ConceptWord AS d ON c.ConceptWordId = d.Id
