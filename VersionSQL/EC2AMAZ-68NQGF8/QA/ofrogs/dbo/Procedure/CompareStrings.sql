/****** Object:  Procedure [dbo].[CompareStrings]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[CompareStrings]
@id int
AS
BEGIN
	SET NOCOUNT ON;

	 declare @Title nvarchar(max)
	 declare @RssFeedItemId int
	
	select @Title = Organization from LinkedInData where id=@id
	
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

	

	select * from #TempModel where confidencescore>0.8
	print 'processed for RssFeedItemId: ' + convert(varchar(11), @RssFeedItemId)

	 declare @TagId int
	select  @TagId =  TagId  from #TempModel 

	declare @Score int
	select  @Score =  confidencescore  from #TempModel 
	if(@Score>0.8)
	 update linkedindata set tagid=@TagId where id=@id
	 else
	  update linkedindata set tagid=0 where id=@id 
END
