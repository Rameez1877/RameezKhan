/****** Object:  View [dbo].[Labels]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.Labels
AS
SELECT        a.Id, a.Name, b.Id AS Expr1, b.Name AS Expr2, c.LabelId, c.ConceptWordId
FROM            dbo.Label AS a INNER JOIN
                         dbo.LabelConceptWord AS c ON a.Id = c.LabelId INNER JOIN
                         dbo.ConceptWord AS b ON c.ConceptWordId = b.Id
