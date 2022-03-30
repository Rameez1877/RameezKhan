/****** Object:  Procedure [dbo].[AnalyzeJobsDataMonster_2017_08_28]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AnalyzeJobsDataMonster_2017_08_28]
	@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Description VARCHAR(1000), @JobTitle VARCHAR(1000)
	/*
	select @RssType = RS.rssTypeId from RssFeedItem RFI, RssFeed RF, Rsssource RS  
	  where RFI.Id = @RssFeedItemId
	  and RFI.RssFeedId = RF.id
	  and RF.RssSourceId = Rs.id and RS.Url like '%monster%'
	  */
	select @Description = dbo.StripHtml(Description), @JobTitle = Title from RssFeedItem where Id = @RssFeedItemId

	DECLARE @localstring NVARCHAR(1000) = @Description 

	---'Company: ', 'Qualification: ', 'Experience: ', 'Summary: ', 'Reference: '

	DECLARE @company NVARCHAR(1000)
	DECLARE @qualification NVARCHAR(1000)
	DECLARE @experience NVARCHAR(1000)
	DECLARE @joblocation NVARCHAR(1000)
	DECLARE @summary NVARCHAR(1000)

	DECLARE @startQualityPos INT = CHARINDEX('Qualification: ',(@localstring))
	DECLARE @startExperiencePos INT = CHARINDEX('Experience: ',(@localstring))
	
	If @startQualityPos > 0 and @startQualityPos > 0
	BEGIN
		SET @company = REPLACE(SUBSTRING(@localstring, 1, @startQualityPos-1),'Company: ','')
		IF @startExperiencePos > @startQualityPos
			SET @qualification  = REPLACE(SUBSTRING(@localstring, @startQualityPos, @startExperiencePos-@startQualityPos),'Qualification: ','')
	END
	ELSE
	BEGIN
		IF @startExperiencePos > 0
			SET @company = REPLACE(SUBSTRING(@localstring, 1, @startExperiencePos-1),'Company: ','')
	END
	
	DECLARE @startLocationPos INT = CHARINDEX('Location: ',(@localstring))
	If @startExperiencePos > 0 and @startLocationPos > 0
		SET @experience  = REPLACE(SUBSTRING(@localstring, @startExperiencePos, @startLocationPos-@startExperiencePos),'Experience: ','')
	
	DECLARE @startRefPos INT = CHARINDEX('Ref: ',(@localstring))
	If @startLocationPos > 0 and @startRefPos > 0
		SET @joblocation  = REPLACE(SUBSTRING(@localstring, @startLocationPos, @startRefPos-@startLocationPos),'location: ','')

	DECLARE @startSummaryPos INT = CHARINDEX('Summary: ',(@localstring))
	IF @startSummaryPos > 0 and @startLocationPos > 0
		SET @summary =   REPLACE(SUBSTRING(@localstring, @startSummaryPos, len(@localstring)-@startLocationPos),'Summary: ','')

	INSERT INTO Jobs  (rssfeeditemid, JobLocation, SenorityLevel, Technology, Functionality,OrganizationName, JobTitle, Summary)
	SELECT @RssFeedItemId rssFeeditemid, @jobLocation as JobLocation, 
	case 
		when (@JobTitle Like '%specialist%' or @JobTitle Like '%supervisor%' OR @JobTitle Like '%Senior%' or @JobTitle Like '%lead%') then 'Senior' 
		when ( @JobTitle Like '%Manager%' or @JobTitle Like '%Principal%' or @JobTitle Like '%Architect%') then 'Middle Management' 
		when (@JobTitle Like '%partner%' or  @JobTitle Like '%Director%' or @JobTitle Like '%President%' or @JobTitle Like '%Chief%' OR @JobTitle Like '%VP%') then 'Top Management' 
		ELSE 'Entry' 
	End
	As SeniorityLevel,
	case 
		WHEN dbo.[fn_GetJobTech_Func_Title](@JobTitle,'Technology') IS NOT NULL THEN  dbo.[fn_GetJobTech_Func_Title](@JobTitle,'Technology')
	ELSE '' 
	End
	As Technology,
	case 
		WHEN dbo.[fn_GetJobTech_Func_Title](@JobTitle,'Functionality') IS NOT NULL THEN  dbo.[fn_GetJobTech_Func_Title](@JobTitle,'Functionality')
	ELSE '' 
	End
	As Functionality,
	@company AS OrganizationName, @JobTitle as JobTitle, @summary as Summary

END
