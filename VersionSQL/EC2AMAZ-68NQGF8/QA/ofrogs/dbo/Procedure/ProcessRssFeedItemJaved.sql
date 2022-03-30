/****** Object:  Procedure [dbo].[ProcessRssFeedItemJaved]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessRssFeedItemJaved]
	 @linkedId int
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

	--declare @News nvarchar(max)
	declare @Title nvarchar(max)
	 declare @RssFeedItemId int
	--select @News = dbo.StripHtml(description) from RssFeedItem where Id = @RssFeedItemId
	select @Title = Organization from LinkedInData where userid=95 and id=@linkedId
	---dbo.StripHtml(Title) from RssFeedItem where Id = @RssFeedItemId

	print 'processed for RssFeedItemId: ' + convert(varchar(11), @Title)
	
	Create Table #TempModel (TagId INT,Name NVARCHAR(100), ConfidenceScore float)
	 
	insert into #TempModel
	select * from
	(

	select T.Id as TagId,T.Name as Name, 
	case
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.fullname+ ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ' %' 
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '^%'
								) then 
								case when len(O.fullname) > 4 then
											CASE when dbo.[fn_GetOrgName_Title](@Title,' ',O.fullname) =1  THEN 1
											ELSE  0.1 END 
									when len(O.fullname) < =4  and   dbo.[fn_GetOrgName_Title](@Title,' ',O.fullname) =1   
									then 0.75
								else 0.0
								end
							
						----Name logic
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ',%'
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + '''%'
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%'
								) Then
								case when len(O.name) > 4 then 
									case 
										when dbo.[fn_GetOrgName_Title](@Title,' ',O.Name) =1  THEN 1
										when @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' then 0.9
										WHEN dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%' then 0.85
										end
									when len(O.Name) < =4  and   dbo.[fn_GetOrgName_Title](@Title,' ',O.Name) =1  
									then 0.75
								else 0.0
								end
						when (@Title +' ' collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + ' %') Then
							case when len(O.name) > 4 AND  dbo.[fn_GetOrgName_Title](@Title,' ',O.Name) =1  THEN 1 
								when len(O.name) > 4	then 0.1
							when len(O.name) < =4  and   dbo.[fn_GetOrgName_Title](@Title,' ',O.Name) =1   
									then 0.75
							 else 0.0 end

						----Name2 logic
						when (@Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' 
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ',%'
								OR @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + '''%'
								OR dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%'
								) Then
								case when len(O.Name2) > 4 then 
									case 
										when dbo.[fn_GetOrgName_Title](@Title,' ',O.Name2) =1 THEN 1
										when @Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' then 0.6
										WHEN dbo.fn_remove_Chars(@Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%' THEN 0.55 
										end
									when len(O.Name2) < =4  and   dbo.[fn_GetOrgName_Title](@Title,' ',O.Name2) =1   
									then 0.75
									else 0.1
									end
						when (@Title+' ' collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '%') Then
							case when len(O.Name2) > 4 AND dbo.[fn_GetOrgName_Title](@Title,' ',O.Name2) =1 THEN 1
							 when len(O.Name2) > 4 
							 then 0.1
							when len(O.Name2) < =4  and   dbo.[fn_GetOrgName_Title](@Title,' ',O.Name2) =1   
									then 0.75
							 else 0.0 end

						else 0 
						end as confidenceScore
	from 
		Tag T
		inner join Organization O on (O.Id = T.OrganizationId)

	where 
		 (@Title like '%' + O.Name + '%' or @Title like '%' + O.Name2 + '%'
		or @Title like '%' + O.fullname+ '%') 
		and O.IsActive = 1 
		and T.tagtypeid = 1
	
	) R

	

	select * from #TempModel where ConfidenceScore>0.8
	print 'processed for RssFeedItemId: ' + convert(varchar(11), @RssFeedItemId)

END
