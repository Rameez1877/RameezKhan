/****** Object:  Procedure [dbo].[CleanseRssFeed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE CleanseRssFeed 
	
AS


    delete from rssfeeditemindustry where rssfeeditemid in (
select id  from rssfeeditem where id in (
select distinct rssfeeditemid from documenttermmatrix where word in ('cricket')
))

delete from rssfeeditemtag where rssfeeditemid in (
select id  from rssfeeditem where id in (
select distinct rssfeeditemid from documenttermmatrix where word in ('cricket')
))

delete from tempDoc2Topic where rssitemfeed in (
select id  from rssfeeditem where id in (
select distinct rssfeeditemid from documenttermmatrix where word in ('cricket')
))


delete   from dbo.tempDoc2Topic where rssitemfeed in (
select id from rssfeeditem where description like '%cricket%'
)

delete   from dbo.tempRssTopicProb where RssFeedItem in (
select id from rssfeeditem where description like '%cricket%'
)

delete from rssfeeditem where description like '%cricket%'
