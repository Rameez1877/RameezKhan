/****** Object:  Procedure [dbo].[Usp_SignalJob_Count_Signal_Words]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_SignalJob_Count_Signal_Words]
@TagId int ,
@IndustryId int,
@SignalId int
	
AS
BEGIN
	SET NOCOUNT ON;

		declare @TagCount int , @IndustryCount int, @ConfidenceScore float
		declare @orgName varchar(max) 
			SET @TagCount = 0;
			set @ConfidenceScore = 0.7
			

		 Select count(*)  from rssfeeditemtag where TagId = @TagId 
		 SET @TagCount = @@ROWCOUNT ;
		 ---select @News = dbo.StripHtml(description) from RssFeedItem where Id = @RssFeedItemId
		
		--Select count(*)  from rssfeeditemindustry where IndustryId = @IndustryId
		--SET @IndustryCount = @@ROWCOUNT ;

		if @TagCount = 0 and @TagId > 0 
			Begin
				select @orgName =  name from organization where isactive = 1 and id in (select organizationid from tag where tagtypeid = 1 and id = @TagID)
				exec [ProcessRssFeedItem2] @orgName, 2017
			End

	DECLARE @SignalKeyWords TABLE 
	(
		SignalId int,
		SignalKeyWord varchar(MAX),
		IndustryID int,
		SignalRssType int
	)

		DECLARE @DomainNews TABLE 
	(
		RssFeedItemId int,
		RssTypeID int,
		IndustryID int,
		TagID int,
		Title nvarchar(800),
		News varchar(max)
	)
		
	if @TagId > 0 and @IndustryId = 0 and @SignalId = 0
		Begin
			insert into @DomainNews
			
			select distinct RFI.Id, RS.rssTypeId , RFII.IndustryID,RFT.TagId, RFI.Title,RFI.news
			from rssfeeditem RFI
			INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
			INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
			INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
			INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
			inner join industrytag IT on IT.industryid = RFII.industryid
			and IT.tagid = RFT.tagid
			where 
			RFT.ConfidenceScore >= @ConfidenceScore and 
			RFT.tagid = @TagId 	
			and RFI.title not like '%active stocks to watch%' and RFI.title not like '%active stock to watch%'		
		End
	
	else if @TagId = 0 and @IndustryId > 0 and @SignalId = 0
			Begin
				insert into @DomainNews
				select distinct RFI.Id, RS.rssTypeId , RFII.IndustryID,RFT.TagId, RFI.Title,RFI.news
				from rssfeeditem RFI
				INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
				INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
				INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
				INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
				inner join industrytag IT on IT.industryid = RFII.industryid
				and IT.tagid = RFT.tagid
	
				where 
				   RFT.ConfidenceScore >= @ConfidenceScore
				 and RFII.industryid = @IndustryId
				 and RFI.title not like '%active stocks to watch%' and RFI.title not like '%active stock to watch%'		
			End

	else if  @TagId = 0 and @IndustryId = 0 and @SignalId = 0
			Begin
				insert into @DomainNews
				select distinct RFI.Id, RS.rssTypeId , RFII.IndustryID,RFT.TagId, RFI.Title,RFI.news
				from rssfeeditem RFI
				INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
				INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
				INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
				INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
				inner join industrytag IT on IT.industryid = RFII.industryid
				 and IT.tagid = RFT.tagid
	
				where 
				  RFT.ConfidenceScore >= @ConfidenceScore
				 and RFI.PubDate>= dateadd(day,datediff(day,1,GETDATE()),0)
				 and  RFI.PubDate < dateadd(day,datediff(day,0,GETDATE()),0)
				 and RFI.title not like '%active stocks to watch%' and RFI.title not like '%active stock to watch%'		
			End

		else if  @TagId = 0 and @IndustryId = 0 and @SignalId > 0
			Begin
				insert into @DomainNews
				select distinct RFI.Id, RS.rssTypeId , RFII.IndustryID,RFT.TagId, RFI.Title,RFI.news
				from rssfeeditem RFI
				INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
				INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
				INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
				INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
				inner join industrytag IT on IT.industryid = RFII.industryid
				 and IT.tagid = RFT.tagid
	
				where 
				  RFT.ConfidenceScore >= @ConfidenceScore
				  --and RFT.rssfeeditemid = 4134492
				  and RFI.title not like '%active stocks to watch%' and RFI.title not like '%active stock to watch%'		
			End
	
	 Else 
		Begin
		print('no news or job identified')
		End

--- Signal and Keywords for Signals--------------
--Each Signal has its own keyword predefined. For ex: M&A signal can have a keyword 'acquires'
	if @SignalId > 0 and @IndustryId = 0 and @TagId = 0
		Begin 
			insert into @SignalKeyWords
			select S.ID as SignalId,  SW.Name as SignalKeyWord , I.IndustryId , S.SignalRssType from 
			industrysignal I, Signal S, SignalWord SW
			where I.SignalID = S.id
			and S.id = SW.SignalID
			and S.id = @SignalId
			--and S.id not in (3,36)
		-- and I.industryID  in (23, 28,2,15,10,17,16,28,39,37)	
		End
	else if @SignalId = 0 and @IndustryId >0  and @TagId = 0
		Begin
			insert into @SignalKeyWords
			select S.ID as SignalId,  SW.Name as SignalKeyWord , I.IndustryId , S.SignalRssType from 
			industrysignal I, Signal S, SignalWord SW
			where I.SignalID = S.id
			and S.id = SW.SignalID
			and I.industryId = @IndustryId
			and S.id not in (11,34,33)
		End
		else 
		Begin
			insert into @SignalKeyWords
				select S.ID as SignalId,  SW.Name as SignalKeyWord , I.IndustryId , S.SignalRssType from 
			industrysignal I, Signal S, SignalWord SW
			where I.SignalID = S.id
			and S.id = SW.SignalID
			and S.id not in ( 11,34,33)
		---	and I.industryId = @IndustryId
		End

	--For every news id, find the signal and applicable keyword 
	---
	Create Table #TempModel (rssfeeditemId INT,SignalId INT, rssTypeId INT, signalKeyWord varchar(MAX),  IndustryID int, TagID int
	)
	 
	 insert into #TempModel
	  select Id, SignalID, RssTypeID, SignalKeyWord,  IndustryID, TagID from (
		select  rssfeeditemid as Id, SW.SignalId as SignalId, ADN.RssTypeID as RssTypeID,	
				SW.SignalKeyWord as SignalKeyWord,
				
				Case
					when  dbo.[fn_GetOrgName_Title](title,' ',SW.SignalKeyWord) =1  then 1 
					when len(SW.SignalKeyWord) > 4 and title Collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '%' then 0.6
					 --when len(SW.SignalKeyWord) <5  and dbo.[fn_GetOrgName_Title](RF.title,' ',SW.SignalKeyWord) =1  then 1
				     when len(SW.SignalKeyWord) <5  and dbo.fn_remove_Chars(title) Collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '^%'  then 1
				     else 0.0 end as Remarks, 
					
				
				ADN.IndustryID as IndustryID, ADN.TagID as TagID
		from 
		@SignalKeyWords SW,  @DomainNews ADN
		where  Title collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '%'  
			and SW.signalID not in (11,34,33)
			and ADN.IndustryID = SW.IndustryID
			and ADN.RssTypeID = SW.SignalRssType
			UNION
			
			select  rssfeeditemid as id, SW.SignalId, ADN.RssTypeID, SW.SignalKeyWord,
			
				Case	
						when dbo.[fn_GetOrgName_Title](news,' ',SW.SignalKeyWord) =1  then 1.0
						when len(SW.SignalKeyWord) > 4 and news like '%' + SW.SignalKeyWord + '%' then 0.9	
					
						 when len(SW.SignalKeyWord) <5 and news like '%' + SW.SignalKeyWord + '^%'  then 0.9
						 when len(SW.SignalKeyWord) <5 and news like '%' + SW.SignalKeyWord + '%'  then 0.6
						 else 0.1 end as Remarks,  
			
		
			ADN.IndustryID,ADN.TagID
		   from 
		  @SignalKeyWords SW,  @DomainNews ADN
		   where 
			News collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '%'  
			 
			and SW.signalID not in (11,34,33,72,73,74)
			and ADN.IndustryID = SW.IndustryID
			and ADN.RssTypeID = SW.SignalRssType
			) R 
			group by Id, SignalID, RssTypeID, SignalKeyWord,  IndustryID, TagID
			having sum(R.remarks) > 0.6
		 
	Create Table #TempTable1 (rssfeeditemId INT,SignalId INT, rssTypeID int, IndustryId INT,TagID int,NoOfSignalWords INT,
	 SignalKeyWord varchar(max)
	)
	insert into #TempTable1


	select TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId, TN2.IndustryId,TN2.TagID,COUNT(TN2.SignalId) AS NoOfSignalWords,
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

		
	--- delete old records. 	
		if @IndustryId > 0 and @TagId = 0  and @SignalId = 0
		Begin
			delete from  RssFeedItemSignal where industryid = @IndustryId
		
		End 
		
		if @SignalId > 0 and @IndustryId = 0  and @TagId = 0
			Begin
				delete from  RssFeedItemSignal where SignalId = @SignalId  --and rssfeeditemid = 4134492
			End 

		if @TagId > 0 and @IndustryId = 0  and @SignalId = 0
		Begin
			delete from  RssFeedItemSignal where TagId = @TagId
		End 

		declare @temp_row_count int
		
		select @temp_row_count = count(*) from #TempTable1
		print 'number of signals' + convert(varchar(max), @temp_row_count)
		if(@temp_row_count > 0)
		begin
			--2017-8-20
			insert into RssFeedItemSignal (RssFeedItemId, SignalId, SignalWord,IndustryId, TagId, ScoreDate) 

			select rssfeeditemId, 
				Case when  SignalId = 3 AND rssTypeID<>3 then  7 
				     when  SignalId = 36 AND rssTypeID<>3 then  22
					 when SignalId = 7 AND rssTypeID=3 then  3
					 when SignalId = 22 AND rssTypeID=3 then  36
					
					else signalid end as NewSignalId
				  , LEFT(SignalKeyWord,50),  IndustryID, TagID, getDate()
				 from
				#TempTable1
				where NoOfSignalWords > 0
				and rssTypeID in (1,2,4,5,3)


				--select rssfeeditemId, 
				--Case when  SignalId = 3 then  7 
				--     when  SignalId = 36 then  22
					
				--	else signalid end as NewSignalId
				--  , LEFT(SignalKeyWord,50),  IndustryID, TagID, getDate()
				-- from
				--#TempTable1
				--where NoOfSignalWords > 0
				--and rssTypeID in (1,2,4,5)
				
				--union 

				--select  rssfeeditemId, 
				--Case  when SignalId = 7 then  3
				--	  when SignalId = 22 then  36
			
				--else signalid end as NewSignalId
				--, LEFT(SignalKeyWord,50),  IndustryID, TagID, getDate()
				--from
				--#TempTable1 TT1
				--where TT1.NoOfSignalWords > 0
				--and TT1.rsstypeid = 3

		end
		
		DROP TABLE #TempTable1
		DROP TABLE #TempModel

END
