/****** Object:  View [dbo].[coneptwordcount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.coneptwordcount
AS
SELECT        TOP (100) PERCENT a.Id, COUNT(*) AS Expr1
FROM            dbo.Label AS a LEFT OUTER JOIN
                         dbo.LabelConceptWord AS b ON a.Id = b.LabelId
GROUP BY a.Id
ORDER BY Expr1
