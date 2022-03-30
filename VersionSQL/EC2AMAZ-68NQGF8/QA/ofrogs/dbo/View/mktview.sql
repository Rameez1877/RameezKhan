/****** Object:  View [dbo].[mktview]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[mktview]
AS


SELECT top 999999999 MONTH(lastupdatedon) AS Mnth, YEAR(lastupdatedon) AS Yr,
 Concat(DATENAME(MONTH,lastupdatedon),'  ',  YEAR(lastupdatedon)) as mdate, COUNT(*) AS Datacount,userid,industryid
FROM linkedindata  where userid>0 and decisionmaker ='DecisionMaker'
GROUP BY industryid,userid,DATENAME(MONTH,lastupdatedon), MONTH(lastupdatedon), YEAR(lastupdatedon) 
order by Mnth
