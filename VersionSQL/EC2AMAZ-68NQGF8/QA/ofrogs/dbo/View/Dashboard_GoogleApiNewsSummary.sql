/****** Object:  View [dbo].[Dashboard_GoogleApiNewsSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Dashboard_GoogleApiNewsSummary]
as
Select convert(date,PubDate) PublishedDate ,  count(*)totalnews from rssfeeditem  
where convert(date,PubDate) 
BETWEEN  DATEADD(DD,-15, convert(date,getdate()))  AND convert(date,getdate()) 
and rssfeedid in 
(select id  from rssfeed  
where rsssourceid in(select id  from rsssource  where industryid=36 
and description='Google News'  and rsstypeid=12))
group by convert(date,PubDate) 
