/****** Object:  View [dbo].[orgview]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[orgview]
AS


SELECT  i.id as 'industryid',LTRIM(RTRIM(i.name)) as 'industryname' ,count(*) as orgcount
FROM industry i ,organization o  where i.id=o.industryid
GROUP BY i.id,i.name
