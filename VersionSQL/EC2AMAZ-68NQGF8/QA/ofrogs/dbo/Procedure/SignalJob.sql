/****** Object:  Procedure [dbo].[SignalJob]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SignalJob]
@IndustryId int
-- change it to SignalRssFeeditem once finalized.
-- change existing SP (SignalRssFeeditem) to oldSignalRssFeeditem
	
AS
BEGIN

	SET NOCOUNT ON;
			DECLARE @SignalKeyWords TABLE 
	(
		SignalId int,
		SignalKeyWord varchar(100),
		IndustryID int
	)

	
		DECLARE @DomainNews TABLE 
	(
		RssFeedItemId int,
		RssTypeID int,
		IndustryID int,
		TagID int
	)

		 
	insert into @DomainNews
	select distinct RFI.Id, RS.rssTypeId , RFII.IndustryID,RFT.TagId
	from rssfeeditem RFI
	INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
	INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
	INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
	INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
	
	where 
	 RFII.IndustryID =@IndustryId--in (23, 10, 17, 37,44)	
	and RFT.confidencescore > 0.54
	 and RFI.PubDate>= dateadd(day,datediff(day,30,GETDATE()),0)
     and  RFI.PubDate < dateadd(day,datediff(day,0,GETDATE()),0)
	 and rs.rsstypeid in (1, 3)
	 and RFI.id not in (select rssfeeditemid from rssfeeditemsignal where industryid = @IndustryId)
	

--- Signal and Keywords for Signals--------------
--Each Signal has its own keyword predefined. For ex: M&A signal can have a keyword 'acquires'
	insert into @SignalKeyWords
	select S.ID as SignalId,  SW.Name as SignalKeyWord , I.IndustryId from 
	industrysignal I, Signal S, SignalWord SW
	where I.SignalID = S.id
	and S.id = SW.SignalID
	and I.industryID=@IndustryId --in (23, 10, 17, 37,44)

	--For every news id, find the signal and applicable keyword 
	Create Table #TempModel (rssfeeditemId INT,SignalId INT, rssTypeId INT
	, SignalKeyWord varchar(1000), IndustryID int, TagID int
	)
	 
	 insert into #TempModel
		select  RF.id, SW.SignalId, ADN.RssTypeID
		, SW.SignalKeyWord, ADN.IndustryID,ADN.TagID
		from 
		@SignalKeyWords SW, rssfeeditem RF,  @DomainNews ADN
		where 
			RF.news  like '%' + SW.SignalKeyWord + '%' 
			and ADN.rssfeeditemid = RF.id 
			and SW.signalID not in (11,34,33)
			and ADN.IndustryID = SW.IndustryID

			UNION

			select  RF.id, SW.SignalId, ADN.RssTypeID
		, SW.SignalKeyWord, ADN.IndustryID,ADN.TagID
		from 
		@SignalKeyWords SW, rssfeeditem RF,  @DomainNews ADN
		where 
			RF.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '%' 
			and ADN.rssfeeditemid = RF.id 
			and SW.signalID not in (11,34,33)
			and ADN.IndustryID = SW.IndustryID
		
	
	Create Table #TempTable1 (rssfeeditemId INT,SignalId INT, rssTypeID int, IndustryId INT,TagID int,NoOfSignalWords INT,
	 SignalKeyWord varchar(1000)
	)
	insert into #TempTable1
	select TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId, TN2.IndustryId,TN2.TagID,
	COUNT(TN2.SignalId) AS NoOfSignalWords,
	STUFF((select distinct ',' + TN1.SignalKeyWord
	from #TempModel TN1
	where 
		TN2.rssfeeditemId = TN1.rssfeeditemId
		and TN2.SignalId = TN1.SignalId 
		and TN2.rssTypeId = TN1.rssTypeId 
		and TN2.IndustryID = TN1.IndustryID
		and TN2.TagID=TN1.TagID
		FOR XML PATH('')),1,1,'') AS SignalKeyWord	
		from #TempModel TN2
		group by TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId,TN2.IndustryId,TN2.TagID

		declare @temp_row_count int
		
		select @temp_row_count = count(*) from #TempModel
		print 'number of signals' + convert(varchar(11), @temp_row_count)
		if(@temp_row_count > 0)
		begin
		--2017-8-20
	    insert into RssFeedItemSignal (RssFeedItemId, SignalId, SignalWord,IndustryId) 
		----values  (RssFeedItemId, SignalId, SignalWord)

		select distinct rssfeeditemId, 
		Case when rssTypeId = 3 and SignalId = 7 then  3
		 when rssTypeID in (1,2,4,5) and SignalId = 3 then  7 
		else signalid end as NewSignalId
		, null,  IndustryID
		from
			#TempTable1
			where NoOfSignalWords > 0
		end
		--2017-8-20
		insert into OutputIndustrySignalAnalysis
	select  distinct null AS RegionName, null As ContinentName, null As CountryName, 
	TN1.IndustryId, RF.id, T.Id as tagId, T.name as tagName, 	
	S.DisplayName, --RF.pubdate,
	Null,
	CASE WHEN ISNULL(PubDate,'2016-03-31')<='2016-3-31 23:59:59' THEN '2016-Q3 OR Before'	
	ELSE CAST(year(PubDate) AS char(4)) + '-Q' + 
    CAST(CEILING(CAST(month(PubDate) AS decimal(4,2)) / 3) AS char(1)) END,
    RF.title, RF.link, RF.PubDate --, REPLACE(CONVERT(VARCHAR(11), RF.PubDate, 0),' ','')
	--,year(RF.pubdate)
	from rssfeeditemsignal RFS
	INNER JOIN Signal S ON RFS.signalId = S.id 
	
	INNER JOIN rssfeeditem RF ON RFS.RssFeedItemId = RF.Id
	INNER JOIN #TempTable1 TN1 ON TN1.rssfeeditemId = RF.Id and TN1.SignalId=S.id

	INNER JOIN tag T ON TN1.tagid= T.id

	where RFS.rssfeeditemid = TN1.rssfeeditemId 
	and year(RF.pubdate) IS NOT NULL
	and t.tagtypeid = 1
	
	order by T.name, S.DisplayName, (RF.PubDate) desc

	DROP TABLE #TempTable1
	DROP TABLE #TempModel

		
	End
