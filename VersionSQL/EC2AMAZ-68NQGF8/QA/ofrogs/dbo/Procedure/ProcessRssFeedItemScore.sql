/****** Object:  Procedure [dbo].[ProcessRssFeedItemScore]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessRssFeedItemScore]
	@RssFeedItemId int
AS
BEGIN
/*
	This stored procedure does the following:
	1. Industry mapping in RssFeedItemIndustry
	2. Tag mapping in RssFeedItemTag
	3. Populates Rootwords
	4. Populates DocumentTermMatrix table for given RssFeedItemId
	5. Scoring 
*/
	SET NOCOUNT ON;

	declare @News nvarchar(max)
	select @News = News from RssFeedItem where Id = @RssFeedItemId

	--if @News is null
	--Begin
	--	update RssFeedItem
	--	set
	--		News = dbo.StripHtml([Description])
	--	where
	--		Id = @RssFeedItemId
	--	select @News = News from RssFeedItem where Id = @RssFeedItemId
	--End

	-- Populate RssFeedItemIndustry Table.//
/*	select T.Id as TagId, O.IndustryId, T.Name 
	into #TempModel
	from 
		Tag T
		inner join Organization O on (O.Name = T.Name)
	where 
		O.IndustryId is not null
		and @News like '%[^a-z0-9]' + T.Name + '[^a-z0-9]%'
		and O.IsActive = 1
		
	delete from RssFeedItemIndustry where RssFeedItemId = @RssFeedItemId

	insert RssFeedItemIndustry(RssFeedItemId, IndustryId)
	select distinct @RssFeedItemId, IndustryId
	from
		#TempModel
	
	delete from RssFeedItemTag where RssFeedItemId = @RssFeedItemId

	insert RssFeedItemTag(RssFeedItemId, TagId)
	select distinct @RssFeedItemId, TagId
	from 
		#TempModel

	--declare @RootWords varchar(max)
	--select @RootWords = RootWords from dbo.RssFeedItem where Id = @RssFeedItemId
	--if @RootWords is null
	--Begin
	--	exec dbo.GenerateDTM @RssFeedItemId
	--End
	*/	

delete from dbo.Score where RssFeedItemId = @RssFeedItemId

	 insert dbo.Score(RssFeedItemId, IndustryId, Score)
	select @RssFeedItemId, D.IndustryId, sum(D.TfIdf) * 1000 as Score
	from 
		dbo.TfIdf D
	--	 inner join GoodWord G on (D.Word = G.RootWord and G.IndustryId = D.IndustryId)
	
	where
		D.RssFeedItemId = @RssFeedItemId
		and D.tfidf is not null
	group by
		D.IndustryId
		
	print 'processed for RssFeedItemId: ' + convert(varchar(11), @RssFeedItemId)
END
