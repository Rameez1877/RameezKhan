/****** Object:  Procedure [dbo].[ProcessRssFeedItem_2017_08_22]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessRssFeedItem_2017_08_22]
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
	declare @Title nvarchar(max)
	select @News = dbo.StripHtml(description) from RssFeedItem where Id = @RssFeedItemId
	select @Title = dbo.StripHtml(Title) from RssFeedItem where Id = @RssFeedItemId
	
	Create Table #TempModel (TagId INT,IndustryId INT,Name VARCHAR(100), ConfidenceLevel INT)
	 
	insert into #TempModel
	select * from
	(

	select T.Id as TagId,O.IndustryId as IndustryId,T.Name as Name, 1 as Confidencelevel
	from 
		Tag T
		inner join Organization O on (O.Id = T.OrganizationId)
		inner join IndustryTag IT on IT.tagid = T.id
	where 
		O.IndustryId = IT.industryid
		and (@Title like '% ' + O.Name + '%' or @Title like '% ' + O.Name2 + ' %'
		or @Title like '% ' + O.fullname+ ' %') 
		and O.IsActive = 1 
		and T.tagtypeid = 1
	
	) R

	

	declare @temp_row_count int

	select @temp_row_count = count(*) from #TempModel

	if(@temp_row_count > 0)
	begin
		delete from RssFeedItemIndustry where RssFeedItemId = @RssFeedItemId
		delete from RssFeedItemTag where RssFeedItemId = @RssFeedItemId

		insert RssFeedItemIndustry(RssFeedItemId, IndustryId)
		select distinct @RssFeedItemId, IndustryId
		from
			#TempModel
	
		

		insert RssFeedItemTag(RssFeedItemId, TagId, Confidencelevel)
		select distinct @RssFeedItemId, TagId, Confidencelevel
		from 
			#TempModel

		--exec signalrssfeeditem @RssFeedItemId

	end
	else
	begin
	


		declare @RssType varchar(max)
		
		select @RssType = (Case 
		when RS.Url like '%indeed%' then 'indeed'
		when RS.Url like '%monster%' then 'monster'
		else 'other' end)
		 from RssFeedItem RFI, RssFeed RF, Rsssource RS  
		where RFI.Id = @RssFeedItemId
		and RFI.RssFeedId = RF.id
		and RF.RssSourceId = Rs.id and 
		RS.rsstypeid = 3
		

		--if @RssType = 'indeed'
		--	Begin
		--	exec AnalyzeJobsDataIndeed @RssFeedItemId
		--	END
		--else if @RssType = 'monster'
		--	Begin
		--	exec AnalyzeJobsDataMonster @RssFeedItemId
		--	END
	  --  print 'else condition' + convert(varchar(11), @RssFeedItemId)
	end
	
	print 'processed for RssFeedItemId: ' + convert(varchar(11), @RssFeedItemId)
END
