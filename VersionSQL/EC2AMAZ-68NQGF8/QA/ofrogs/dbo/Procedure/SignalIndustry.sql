/****** Object:  Procedure [dbo].[SignalIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SignalIndustry]
	@IndustryID int,
@SignalIndustry int
	
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;
	--declare @IndustryID int
	--Select @IndustryID  = industryid from rssfeeditemindustry where rssfeeditemid = @RssFeedItemId
		-- Insert statements for procedure here
		DECLARE @SignalKeyWords TABLE 
	(
		SignalId int,
		SignalKeyWord varchar(100)
	)

	
		DECLARE @DomainNews TABLE 
	(
		RssFeedItemId int,
		RssTypeID int
	)

		 
	insert into @DomainNews
	select distinct RFI.Id, RS.rssTypeId 
	from rssfeeditem RFI
	INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
	INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
	INNER join rssfeeditemindustry RFII on RFII.RssFeedItemId = RFI.Id
	INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
	
	
	where 
	 RFII.IndustryID = @IndustryID
	 ---and RS.isactive = 1
	 and RFT.ConfidenceScore > 0.5
	
	

--- Signal and Keywords for Signals--------------
--Each Signal has its own keyword predefined. For ex: M&A signal can have a keyword 'acquires'
	insert into @SignalKeyWords
	select S.ID as SignalId,  SW.Name as SignalKeyWord from 
	industrysignal I, Signal S, SignalWord SW
	where I.SignalID = S.id
	and S.id = SW.SignalID
	and I.industryID = @SignalIndustry  --@IndustryID


	--For every news id, find the signal and applicable keyword 
	Create Table #TempModel (rssfeeditemId INT,SignalId INT, rssTypeId INT
	, SignalKeyWord varchar(1000)
	)
	 
	 insert into #TempModel
		select  RF.id, SW.SignalId, ADN.RssTypeID
		, SW.SignalKeyWord
		from 
		@SignalKeyWords SW, rssfeeditem RF,  @DomainNews ADN
		where 
			RF.news  like '%' + SW.SignalKeyWord + '%' 
			and ADN.rssfeeditemid = RF.id 
			and SW.signalID not in (11,34,33)
		
			--For every news id, find the signal and applicable keyword 

	--UPDATE t1
	--SET t1.SignalId = 3
	--FROM #TempModel t1
	--INNER JOIN @DomainNews DN ON DN.rssfeeditemId = t1.rssfeeditemId 
	--WHERE 
	-- t1.SignalId = 7
	-- and DN.RssTypeID

	Create Table #TempTable1 (rssfeeditemId INT,SignalId INT, rssTypeID int,
	 SignalKeyWord varchar(1000)
	)
	insert into #TempTable1
	select TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId, 
	STUFF((select distinct ',' + TN1.SignalKeyWord
	from #TempModel TN1
	where 
		TN2.rssfeeditemId = TN1.rssfeeditemId
		and TN2.SignalId = TN1.SignalId 
		and TN2.rssTypeId = TN1.rssTypeId 
		FOR XML PATH('')),1,1,'') AS SignalKeyWord	
		from #TempModel TN2
		group by TN2.rssfeeditemId, TN2.SignalId, TN2.rssTypeId

		declare @temp_row_count int

		select @temp_row_count = count(*) from #TempModel
		print 'number of signals' + convert(varchar(11), @temp_row_count)
		if(@temp_row_count > 0)
		begin
		
	--	delete from RssFeedItemSignal where industryid = @IndustryID
		insert into RssFeedItemSignal (RssFeedItemId, SignalId, SignalWord,IndustryId) 
		--values  (RssFeedItemId, SignalId, SignalWord)

		select distinct rssfeeditemId, 
		Case when rssTypeId = 3 and SignalId = 7 then  3
		 when rssTypeID in (1,2,4,5) and SignalId = 3 then  7 
		else signalid end as NewSignalId
		, null,  @IndustryID
		from
			#TempTable1
		end

		---------------------------------------------------
	--	exec preparesignalboard @IndustryID
	--	exec preparesignalboardscore @IndustryID


END
