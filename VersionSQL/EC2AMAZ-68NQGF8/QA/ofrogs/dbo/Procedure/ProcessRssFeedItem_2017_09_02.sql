/****** Object:  Procedure [dbo].[ProcessRssFeedItem_2017_09_02]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessRssFeedItem_2017_09_02]
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
	
	Create Table #TempModel (TagId INT,IndustryId INT,Name NVARCHAR(100), ConfidenceScore float)
	 
	insert into #TempModel
	select * from
	(

	select T.Id as TagId,O.IndustryId as IndustryId,T.Name as Name, 
	case
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.fullname+ ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ' %' 
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '^%'
								) then 
								case when len(O.fullname) > 4 then 1
								else 0.7
								--when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.fullname+ ' %' 
								--OR @Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ' %') then 0.5
								--when dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '^%' then 0.35
								
								end
						----Name logic
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ',%'
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + '''%'
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%'
								) Then
								case when len(O.name) > 4 then 
									case 
										when @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' then 0.9
										WHEN dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%' then 0.85
										end
									else 0.7
									end
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '%') Then
							case when len(O.name) > 4 then 0.7 else 0.55 end
						----Name2 logic
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ',%'
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + '''%'
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%'
								) Then
								case when len(O.Name2) > 4 then 
									case 
										when @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' then 0.6
										WHEN dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%' THEN 0.55 
										end
									else 0.45
									end
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '%') Then
							case when len(O.Name2) > 4 then 0.4 else 0.35 end

						else 0 
						end as confidenceScore
	from 
		Tag T
		inner join Organization O on (O.Id = T.OrganizationId)
		inner join IndustryTag IT on IT.tagid = T.id
	where 
		O.IndustryId = IT.industryid
		and (@Title like '%' + O.Name + '%' or @Title like '%' + O.Name2 + '%'
		or @Title like '%' + O.fullname+ '%') 
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
	
		

		insert RssFeedItemTag(RssFeedItemId, TagId, Confidencelevel,ConfidenceScore)
		select distinct @RssFeedItemId, TagId, 1 AS Confidencelevel, confidenceScore+ CASE WHEN  dbo.[fn_SplitString](@Title,' ',IndustryId) =1  THEN 0.05
						ELSE 0 END AS ConfidenceScore
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
