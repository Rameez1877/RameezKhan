/****** Object:  Procedure [dbo].[SignalRssFeedItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SignalRssFeedItem]
	@RssFeedItemId int
	
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;
	declare @IndustryID int
	Select @IndustryID  = industryid from rssfeeditemindustry where rssfeeditemid = @RssFeedItemId 
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
	 RFI.Id = @RssFeedItemId
	--- and RS.isactive = 1
	 and RFT.confidencescore >0.4
	 

	

--- Signal and Keywords for Signals--------------
--Each Signal has its own keyword predefined. For ex: M&A signal can have a keyword 'acquires'
	insert into @SignalKeyWords
	select S.ID as SignalId,  SW.Name as SignalKeyWord from 
	industrysignal I, Signal S, SignalWord SW
	where I.SignalID = S.id
	and S.id = SW.SignalID
	and I.industryID = @IndustryId

	--For every news id, find the signal and applicable keyword 
	Create Table #TempModel (rssfeeditemId INT,SignalId INT, rssTypeId INT
	, SignalKeyWord varchar(100)
	)
	 
	 insert into #TempModel
		select  RF.id, SW.SignalId, ADN.RssTypeID
		, SW.SignalKeyWord
		from 
		@SignalKeyWords SW, rssfeeditem RF,  @DomainNews ADN
		where 
			RF.News like '%' + SW.SignalKeyWord + '%' 
			and ADN.rssfeeditemid = RF.id 
			and SW.signalID not in (11,34,33)

		union 

		select  RF.id, SW.SignalId, ADN.RssTypeID
		, SW.SignalKeyWord
		from 
		@SignalKeyWords SW, rssfeeditem RF,  @DomainNews ADN
		where 
			RF.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + SW.SignalKeyWord + '%' 
			and ADN.rssfeeditemid = RF.id 
			and SW.signalID not in (11,34,33)
	

		declare @temp_row_count int
		select @temp_row_count = count(*) from #TempModel
		--print 'number of signals' + convert(varchar(11), @temp_row_count)
		
		--declare @DomainNews_row_count int
		--select @DomainNews_row_count = count(*) from @DomainNews
		--print 'number of domainnews' + convert(varchar(11), @DomainNews_row_count)

		--declare @SignalKeyword_row_count int
		--select @SignalKeyword_row_count = count(*) from @SignalKeyWords
		--print 'number of signalkeywords' + convert(varchar(11), @SignalKeyword_row_count)

		if(@temp_row_count > 0)
		begin
		insert into RssFeedItemSignal(RssFeedItemId, SignalId, SignalWord, IndustryId)

		select distinct rssfeeditemId, 
		Case when rssTypeId = 3 and SignalId = 7 then  3
		     when rssTypeId in (1,2,4,5) and SignalId = 3 then 7
		else SignalId end as NewSignalId
		, SignalKeyWord, @IndustryID
		from
			#TempModel
		end

		------------------------------------------------------


	

END
