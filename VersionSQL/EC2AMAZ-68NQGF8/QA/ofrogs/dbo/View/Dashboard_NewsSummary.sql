/****** Object:  View [dbo].[Dashboard_NewsSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Dashboard_NewsSummary]
as
--Select   pubdate PublishedDate, Count(*) newscount from rssfeeditem 
--where  convert(date,pubdate) 
--BETWEEN  DATEADD(DD,-15, convert(date,getdate()))  AND convert(date,getdate()) 
--GROUP BY pubdate

Select convert(date,pubdate)  PubDate, Count(*)  newscount from rssfeeditem 
where  convert(date,pubdate) 
BETWEEN  DATEADD(DD,-15, convert(date,getdate()))  AND convert(date,getdate()) 
GROUP BY convert(date,pubdate)
