/****** Object:  Procedure [dbo].[AnalyzeJobsDataIndeed_2017_08_28]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AnalyzeJobsDataIndeed_2017_08_28]
	@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RssType VARCHAR(1000), @Title VARCHAR(1000), @RssURL VARCHAR(1000)
	select @RssType = RS.rssTypeId from RssFeedItem RFI, RssFeed RF, Rsssource RS  
	  where RFI.Id = @RssFeedItemId
	  and RFI.RssFeedId = RF.id
	  and RF.RssSourceId = Rs.id and RS.Url like '%indeed%'

	  select @RssURL = RS.url from RssFeedItem RFI, RssFeed RF, Rsssource RS  
	  where RFI.Id = @RssFeedItemId
	  and RFI.RssFeedId = RF.id
	  and RF.RssSourceId = Rs.id 

	select @Title = dbo.StripHtml(Title) from RssFeedItem where Id = @RssFeedItemId
	

	--DECLARE @searchstring NVARCHAR(400) = 'Paralegal - Zieve, Brodnax & Steele, LLP - Mountlake Terrace, WA'
	--SET @Title = 'Physician (Thoracic Surgeon - Scientist) - Veterans Affairs, Veterans Health Administration - Los Angeles, CA'
	DECLARE @localstring NVARCHAR(1000) = @Title 

	--'AW ,ecarreT ekaltnuoM - PLL ,eleetS & xandorB ,eveiZ - lagelaraP' -- Gives the positon offirst letter starting after ' - ' in the reversed string
	DECLARE @endpos INT = CHARINDEX('-',REVERSE(@localstring)) + 1

	--'AW ,ecarreT ekaltnuoM - Get the location of job in reversed string
	DECLARE @jobLocation NVARCHAR(1000) = REVERSE(SUBSTRING(REVERSE(@localstring), 1, @endpos-2))

	--PLL ,eleetS & xandorB ,eveiZ - lagelaraP -- Removes the last word in the string
	DECLARE @newlocalstring NVARCHAR(1000) = REVERSE(LEFT(@localstring, len(@localstring)-@endpos+1))

	--Zieve, Brodnax & Steele, LLP .........Get the first part of shortenend reverse string which is OrganizationName
	DECLARE @newendpos INT = CHARINDEX(' - ',@newlocalstring)-1
	DECLARE @OrgName NVARCHAR(1000) = REVERSE(SUBSTRING(@newlocalstring, 1, @newendpos)) 

	--Paralegal .........Get the second part of shortenend reverse string which is JobTitle details
	DECLARE @JobTitle NVARCHAR(1000) = REVERSE(SUBSTRING(@newlocalstring, @newendpos+2,Len(@newlocalstring)-@newendpos-3)) 

	INSERT INTO Jobs  (rssfeeditemid, JobLocation, SenorityLevel, Technology, Functionality,
	OrganizationName, JobTitle, JobCountry, JobSource, Inference)
	SELECT @RssFeedItemId, @jobLocation, 
	case 
		when (@JobTitle Like '%specialist%' or @JobTitle Like '%supervisor%' OR @JobTitle Like '%Senior%' or @JobTitle Like '%lead%') then 'Senior' 
		when ( @JobTitle Like '%Manager%' or @JobTitle Like '%Principal%' or @JobTitle Like '%Architect%') then 'Middle Management' 
		when (@JobTitle Like '%partner%' or @JobTitle Like '%Director%' or @JobTitle Like '%President%' or @JobTitle Like '%Chief%' OR @JobTitle Like '%VP%') then 'Top Management' 
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
	@OrgName, @JobTitle, 
	Case when @RssURL like '%indeed.com%' or @RssURL like '%monster.com' then 'USA' 
		 when @RssURL like '%indeed.in%' or @RssURL like '%monster.in' then 'India' 
		 when @RssURL like '%indeed.sg%' or @RssURL like '%monster.sg' then 'Singapore' 
		 else null end as JobCountry,
	Case when @RssURL like '%indeed%' then 'indeed'
	when @RssURL like '%monster%' then 'monster'
	when @RssURL like '%avjobs%' then 'avjobs'
	else 'other' end as JobSource,
	
	case 
		when (@JobTitle Like '%specialist%' or @JobTitle Like '%supervisor%' OR @JobTitle Like '%Senior%' or @JobTitle Like '%lead%') then 'Building team in this area'
		when ( @JobTitle Like '%Manager%' or @JobTitle Like '%Principal%' or @JobTitle Like '%Architect%') then 'building and investing in current team in this area'
		when (@JobTitle Like '%partner%' or @JobTitle Like '%Director%' or @JobTitle Like '%President%' or @JobTitle Like '%Chief%' OR @JobTitle Like '%VP%') then 'strategically investing or continue to invest in this area'
		ELSE 'Still Figuring out Strategy' end as Inference

	



END
