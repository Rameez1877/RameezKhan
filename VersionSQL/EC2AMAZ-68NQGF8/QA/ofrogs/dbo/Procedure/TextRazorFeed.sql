/****** Object:  Procedure [dbo].[TextRazorFeed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[TextRazorFeed]
	-- Add the parameters for the stored procedure here
	@industryid varchar(2) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--	select top(2) * from rssfeeditem where description like '%nestle%' or description like '%honeywell%' 

--select * from rssfeeditem where id  in (
--select a.rssfeeditemid from rssfeeditemtag a, rssfeeditemindustry b where a.tagid in (1457, 4573, 4574)
--and a.RssFeedItemId = b.RssFeedItemId and b.industryid = 9)

----select distinct top(5000) RFI.Id,RFI.RssFeedId,RFI.Title,RFI.Link,RFI.Description,
----RFI.PubDate,RFI.Guid,RFI.RootWords,RFI.Tags,RFI.IsActive,RFI.StatusId,RFI.News,
----RFI.WordCount,RFI.ValidationDate,RFI.tagStatus
----from rssfeeditem RFI join RssFeedItemTag RFIT on RFI.Id = RFIT.RssFeedItemId join RssFeed RF on RF.Id = RFI.RssFeedId
----join RssSource RS on RS.Id = RF.RssSourceId where
----RS.SourceTypeId != 5 and
----year(RFI.PubDate) in (2017,2016) and 
----RFI.id in (select distinct rssfeeditemid from rssfeeditemindustry where industryid = @industryid
----and textrazorrundate is null ) 
----order by RFI.pubdate desc

select Id,RssFeedId,Title, REPLACE(REPLACE(link, CHAR(13), ''), CHAR(10), '') As Link,Description,PubDate,Guid,RootWords,Tags,IsActive,StatusId,News,WordCount,ValidationDate,tagStatus
FROM 
 (select 
distinct top(2500) RF.Id,RF.RssFeedId,RF.Title, 
--REPLACE(REPLACE(RF.link, CHAR(13), ''), CHAR(10), '') As Link,
REPLACE(REPLACE(SUBSTRING(RF.link, CHARINDEX('url=', RF.link), LEN(RF.link)), ',', ''),'url=','')  As Link, 
RF.Description,
RF.PubDate,RF.Guid,RF.RootWords,RF.Tags,RF.IsActive,RF.StatusId,RF.News,
RF.WordCount,RF.ValidationDate,RF.tagStatus
from 
 rssfeeditem RF 
 INNER JOIN rssfeeditemindustry RFI ON RFI.RssFeedItemId = RF.id 
 inner join  rssfeeditemtag RFT on RFT.RssFeedItemId = RF.id 
 inner join industrytag IT on RFI.industryid = IT.industryId and RFI.TextRazorRunDate is null
 where  RFI.IndustryId in (36)
 and IT.tagid = RFT.tagid
 -- and year(RF.pubdate)  = 2017 
--and RF.id IN ( 2569224 )
 and RF.Title NOT LIKE 'Video%' 
and link not like '%forbe%' and link not like '%flightglobal%' and link not like '%http://feeds.reuters.com/%'
and link not like '%pdf'
and link not like '%sciencedaily%'  and link not like '%railwayage%' and link not like '%dx.doi.org%' 
and link not like '%usnews.com%' and link not like '%indeed.com%'
and RF.RssFeedId in
(select id from rssfeed where rsssourceid in (
select id from rsssource where rsstypeid in (1)
and industryid = 36
))
ORDER BY RF.pubdate DESC
) X
--UNION
--select Id,RssFeedId,Title, REPLACE(REPLACE(link, CHAR(13), ''), CHAR(10), '') As Link,Description,PubDate,Guid,RootWords,Tags,IsActive,StatusId,News,WordCount,ValidationDate,tagStatus
--FROM 
-- (select 
--distinct top(2500) RF.Id,RF.RssFeedId,RF.Title, 
----REPLACE(REPLACE(RF.link, CHAR(13), ''), CHAR(10), '') As Link,
--REPLACE(REPLACE(SUBSTRING(RF.link, CHARINDEX('url=', RF.link), LEN(RF.link)), ',', ''),'url=','')  As Link, 
--RF.Description,
--RF.PubDate,RF.Guid,RF.RootWords,RF.Tags,RF.IsActive,RF.StatusId,RF.News,
--RF.WordCount,RF.ValidationDate,RF.tagStatus
--from 
-- rssfeeditem RF 
-- INNER JOIN rssfeeditemindustry RFI ON RFI.RssFeedItemId = RF.id 
-- inner join  rssfeeditemtag RFT on RFT.RssFeedItemId = RF.id  aND RFT.ConfidenceScore > 0.7
-- INNER JOIN RssFeedItemSignal RFS ON  RFS.rssfeeditemid = RF.id AND RFS.IndustryId = RFI.IndustryId AND RFS.TagId = RFT.TagId
-- inner join industrytag IT on RFI.industryid = IT.industryId and RFI.TextRazorRunDate is null
--  where  RFI.IndustryId in (23)
-- AND ISNULL(CONVERT(date, RFI.TextRazorRunDate),CONVERT(date, getdate()))  <> CONVERT(date, getdate()-1)
-- and IT.tagid = RFT.tagid
-- --and year(RF.pubdate)  = 2017 
----and RF.id IN ( 2569224 )
-- and RF.Title NOT LIKE 'Video%' 
--and link not like '%forbe%' and link not like '%flightglobal%' and link not like '%http://feeds.reuters.com/%'
--and link not like '%pdf'
--and link not like '%sciencedaily%'  and link not like '%railwayage%' and link not like '%dx.doi.org%' 
--and link not like '%usnews.com%' and link not like '%indeed.com%'
--and RF.RssFeedId in
--(select id from rssfeed where rsssourceid in (
--select id from rsssource where rsstypeid in (1)
--and industryid <> 36
--))
--ORDER BY RF.pubdate DESC
--) X



	--select T.Id as TagId,O.IndustryId as IndustryId,T.Name as Name, 1 as Confidencelevel
	--from 
	--	Tag T,
	--	Organization O, rssfeeditem RFI
	--where 
	--	O.IndustryId is not null
	--	and (O.Id = T.OrganizationId)
	--	and (RFI.Title Collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name 
	--	+ ' %' ) 
	--	and O.IsActive = 1 
	--	and T.tagtypeid = 1
	--	and RFI.id = 4113608

		--select  * from rssfeeditem where id = 4113608
		--select * from organization where name like 'ÍNG%'
		--update organization set name2 = name where name2 is null and isactive = 1 
		--and id  = 2710

--select * from rsssource where 

--or
--RFI.id in(select distinct a.rssfeeditemid from rssfeeditemtag a, tag b,  
--ofuser.customertargetlist ctl, rssfeeditemindustry rfi
-- where a.tagid = b.id and 
-- b.organizationid = ctl.organizationid  
-- ---and ctl.appuserid in (68, 70, 71)
-- and ctl.appuserid in (8, 37, 68, 70, 71)
-- and rfi.rssfeeditemid = a.rssfeeditemid 
-- and rfi.textrazorrundate is null)






--select * from rssfeeditem RFI where RFI.id > 3952297
---select min(id), max(id) from rssfeeditem where rssfeedid = 9198138


---select distinct
-- RFI.Id,RFI.RssFeedId,RFI.Title,RFI.Link,RFI.Description,
--RFI.PubDate,RFI.Guid,RFI.RootWords,RFI.Tags,RFI.IsActive,RFI.StatusId,RFI.News,
---RFI.WordCount,RFI.ValidationDate,RFI.tagStatus 

---from rssfeeditem RFI 
--where  

--'%[^a-z0-9]' + RFI.description  + '[^a-z0-9]%' like '%ICICI%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%HSBC%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%HDFC%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%reliance retail%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%accenture%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%SBI%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%mphassis%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%kotak mahindra%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%future retail%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%shopper stop%' or
--'%[^a-z0-9]' + RFI.description + '[^a-z0-9]%' like '%axis bank%' 

--order by RFI.pubdate desc

---and year(pubdate) in (2016, 2017, 2015) and link not like '%www.nytimes.com%' 
---and link not like '%news.google.com%' and link not like '%www.flightglobal[.]com%'




--     select top(5000) * from rssfeeditem
--where isactive = 1 and validationdate is not null 
 --and id in (select rssfeeditemid from rssfeeditemindustry where industryid = @industryid 
 --and textrazorrundate is null)
--and id not in (select a.rssfeeditemid from categoryscore a , category b where a.categoryid = b.id and b.industryid = @industryid)

END	
