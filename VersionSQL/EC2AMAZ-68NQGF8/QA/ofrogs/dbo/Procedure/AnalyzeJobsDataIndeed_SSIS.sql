/****** Object:  Procedure [dbo].[AnalyzeJobsDataIndeed_SSIS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AnalyzeJobsDataIndeed_SSIS]
	--@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE @RssType VARCHAR(1000), @Title VARCHAR(1000), @RssURL VARCHAR(1000)
	--select @RssType = RS.rssTypeId from RssFeedItem RFI, RssFeed RF, Rsssource RS  
	--  where RFI.Id = @RssFeedItemId
	--  and RFI.RssFeedId = RF.id
	--  and RF.RssSourceId = Rs.id and RS.Url like '%indeed%'
	
	;WITH cte AS  
	(
		SELECT DISTINCT o.Name, LTRIM(RTRIM(REPLACE(Org_Name,'"','')))  AS Company,o.id from job_excelrawdata  t
		INNER join organization o
		ON o.Fullname =LTRIM(RTRIM(REPLACE(t.Org_Name,'"','')))  collate SQL_Latin1_General_CP1_CI_AS or o.name=LTRIM(RTRIM(REPLACE(t.Org_Name,'"',''))) collate SQL_Latin1_General_CP1_CI_AS or o.name2=LTRIM(RTRIM(REPLACE(t.Org_Name,'"',''))) collate SQL_Latin1_General_CP1_CI_AS
		WHERE ISNULL(o.isActive,0)=1
	)
	--SELECT * FROM cte
	, CETOrgID AS
	(
		select *, ROW_NUMBER()OVER(PARTITION BY Company ORDER BY id DESC ) AS rwnum from cte
	) 
	--SELECT * FROM CETOrgID
	SELECT * INTO #Org fROM CETOrgID WHERE rwnum=1
	--select * from #Org

	select LTRIM(RTRIM(REPLACE(JobName,'"',''))) AS Title,LTRIM(RTRIM(REPLACE(jobLocation,'"',''))) AS jobLocation, t.Name, t.ID, f.ID as rssfeeditemid, f.Link As RSSURL  	
	INTO #temp
	  from job_excelrawdata(NOLOCK) e INNER JOIN #Org t ON  LTRIM(RTRIM(REPLACE(e.Org_Name,'"',''))) =t.Company AND rwnum=1
	  INNER JOIN tempRssFeedItemId(NOLOCK) f ON f.Link=e.BaseURL+e.JobURL
	  where f.ID NOT IN
		  (
				SELECT rssfeeditemid FROM Jobs(NOLOCK)
		  )


	  --select @RssURL = RS.url from RssFeedItem RFI, RssFeed RF, Rsssource RS  
	  --where RFI.Id = @RssFeedItemId
	  --and RFI.RssFeedId = RF.id
	  --and RF.RssSourceId = Rs.id 

	INSERT INTO Jobs  (rssfeeditemid, JobLocation, SenorityLevel, Technology, Functionality,
	OrganizationName, JobTitle, JobCountry, JobSource, Inference)
	SELECT rssfeeditemid,JobLocation,
	case 
		when (Title Like '%specialist%' or Title Like '%supervisor%' OR Title Like '%Senior%' or Title Like '%lead%') then 'Senior' 
		when ( Title Like '%Manager%' or Title Like '%Principal%' or Title Like '%Architect%') then 'Middle Management' 
		when (Title Like '%partner%' or Title Like '%Director%' or Title Like '%President%' or Title Like '%Chief%' OR Title Like '%VP%') then 'Top Management' 
		ELSE 'Entry' 
	End
	As SeniorityLevel,
	case 
		WHEN dbo.[fn_GetJobTech_Func_Title](Title,'Technology') IS NOT NULL THEN  dbo.[fn_GetJobTech_Func_Title](Title,'Technology')
	ELSE '' 
	End
	As Technology,
	case 
		WHEN dbo.[fn_GetJobTech_Func_Title](Title,'Functionality') IS NOT NULL THEN  dbo.[fn_GetJobTech_Func_Title](Title,'Functionality')
	ELSE '' 
	End
	As Functionality, Name AS OrganizationName, Title JobTitle,
	Case when RSSURL like '%indeed.com%' or RSSURL like '%monster.com' then 'USA' 
		 when RSSURL like '%indeed.in%' or RSSURL like '%monster.in' then 'India' 
		 when RSSURL like '%indeed.sg%' or RSSURL like '%monster.sg' then 'Singapore' 
		 else null end as JobCountry,
	Case when RSSURL like '%indeed%' then 'indeed'
	when RSSURL like '%monster%' then 'monster'
	when RSSURL like '%avjobs%' then 'avjobs'
	else 'other' end as JobSource,
	case 
		when (Title Like '%specialist%' or Title Like '%supervisor%' OR Title Like '%Senior%' or Title Like '%lead%') then 'Building team in this area'
		when ( Title Like '%Manager%' or Title Like '%Principal%' or Title Like '%Architect%') then 'building and investing in current team in this area'
		when (Title Like '%partner%' or Title Like '%Director%' or Title Like '%President%' or Title Like '%Chief%' OR Title Like '%VP%') then 'strategically investing or continue to invest in this area'
		ELSE 'Still Figuring out Strategy' end as Inference
	  FROM #temp

	

	DROP TABLE #temp
	DROP TABLE #Org


END
