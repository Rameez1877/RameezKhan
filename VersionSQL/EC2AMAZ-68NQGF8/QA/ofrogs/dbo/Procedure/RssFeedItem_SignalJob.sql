/****** Object:  Procedure [dbo].[RssFeedItem_SignalJob]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[RssFeedItem_SignalJob]
@RssFeedItemId int
	
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
	 RFI.id = @RssFeedItemId
	 and RFT.confidencelevel > 0.4
	

--- Signal and Keywords for Signals--------------
--Each Signal has its own keyword predefined. For ex: M&A signal can have a keyword 'acquires'
	insert into @SignalKeyWords
	select S.ID as SignalId,  SW.Name as SignalKeyWord , I.IndustryId from 
	industrysignal I, Signal S, SignalWord SW
	where I.SignalID = S.id
	and S.id = SW.SignalID
	and I.industryID in (23, 10, 17, 37,44, 46, 2, 37, 28)

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
		
	
	Create Table #TempTable1 (rssfeeditemId INT,SignalId INT, rssTypeID int, IndustryId INT,TagID int,
	 SignalKeyWord varchar(100)
	)
	insert into #TempTable1
	select TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId, TN2.IndustryId,TN2.TagID,
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
		end
		--2017-8-20
		insert into OutputIndustrySignalAnalysis
	select  distinct null AS RegionName, null As ContinentName, null As CountryName, 
	TN1.IndustryId, RF.id, T.Id as tagId, T.name as tagName, 	
	S.DisplayName, --RF.pubdate,
	Null,
	CAST(year(PubDate) AS char(4)) + '- Q' + 
    CAST(CEILING(CAST(month(PubDate) AS decimal(4,2)) / 3) AS char(1)),
    RF.title, RF.link, RF.PubDate --, REPLACE(CONVERT(VARCHAR(11), RF.PubDate, 0),' ','')
	--,year(RF.pubdate)
	from rssfeeditemsignal RFS
	INNER JOIN Signal S ON RFS.signalId = S.id 
	
	INNER JOIN rssfeeditem RF ON RFS.RssFeedItemId = RF.Id
	INNER JOIN #TempTable1 TN1 ON TN1.rssfeeditemId = RF.Id and TN1.SignalId=S.id
	--INNER JOIN RssFeedItemIndustry RFII ON RFII.rssfeeditemid = RF.id 
	--INNER JOIN rssfeeditemtag RFT ON RF.id = RFT.rssfeeditemid
	INNER JOIN tag T ON TN1.tagid= T.id
	--INNER JOIN IndustryTag IT on IT.industryID = TN1.IndustryId and IT.TagId = T.id
	--INNER JOIN IndustrySignal Isi ON Isi.IndustryId = RFII.IndustryId AND Isi.signalId = RFS.SignalId
	
	--LEFT OUTER JOIN Organization Org ON T.OrganizationId = Org.Id
	--LEFT OUTER JOIN Country Cntry ON Org.CountryId = Cntry.ID
	--LEFT OUTER JOIN Continent ON Continent.Id = Cntry.ContinentId
	--LEFT OUTER JOIN Region ON Region.Id = Org.RegionId
	where RFS.rssfeeditemid = TN1.rssfeeditemId 
	and year(RF.pubdate) IS NOT NULL
	---and TN1.tagid in (268, 3263 ,266, 398)
	and t.tagtypeid = 1
	--and Org.isactive = 1 
	--	and I.industryID in (23, 10, 17, 37,44, 46, 2, 37, 28)
    --and Isi.IndustryId = @SignalIndustry
	--and S.id = @SignalId
    --and RFT.Confidencescore = 1
	--and RFS.rssfeeditemid in (select rssfeeditemid from rssfeeditemsignal where signalid = 11)
	order by T.name, S.DisplayName, (RF.PubDate) desc

	DROP TABLE #TempTable1
	DROP TABLE #TempModel
		
	End
