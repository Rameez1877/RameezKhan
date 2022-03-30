/****** Object:  Procedure [dbo].[AnalyzeJobsDataMonster]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AnalyzeJobsDataMonster]
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
		when (@JobTitle Like '%maintenance planning%' or 
		@JobTitle Like '%scheduling%') then 'Planning and Scheduling' 
		when (@JobTitle Like '%microsoft bi%'  or @JobTitle Like '%power bi%' 
		or @JobTitle Like '%SSIS %' or @JobTitle Like '%SSAS %' OR @JobTitle Like '%powerbi%') then 'Microsoft BI' 
		when (@JobTitle Like '%Tableau%' ) then 'Tableau' 
		when (@JobTitle Like '%Qlik%' ) then 'Qlikview'
		when (@JobTitle Like '%android%') then 'Android' 
		when (@JobTitle Like '%informatica%') then 'Informatica'
		when (@JobTitle Like '%AngularJS%') then 'Angular'
		when (@JobTitle Like '%Oracle HCM%' or @JobTitle Like '%Oracle Fusion') then 'Oracle HCM'
		when (@JobTitle Like '%MongoDB%') then 'MongoDB'
		when (@JobTitle Like '%Oracle%') then 'Oracle' 		
		when (@JobTitle Like '%success factor%') then 'HR Successfactor'	
		when (@JobTitle Like '%.Net%') then 'Net' 				
		when (@JobTitle Like '%.Java%') then 'Java' 			
			when (@JobTitle Like 'C#%') then 'C Sharp' 	
			when (@JobTitle Like '% VB %') then 'Visual Basic' 	
		when (@JobTitle Like 'Azure') then 'Azure' 	
		when (@JobTitle Like '% AWS %' or @JobTitle Like '%Amazon Web Service%' ) then 'AWS' 		
		when (@JobTitle Like 'AJAX') then 'AJAX' 		
			when (@JobTitle Like '%DHTML%') then 'DHTML' 	
		when (@JobTitle Like '%silverlight%') then 'silverlight' 
		when (@JobTitle Like 'salesforce') then 'salesforce' 
		when (@JobTitle Like '%Ruby on rail%' or @JobTitle Like '%Ruby%') then 'Ruby on rail' 
		when (@JobTitle Like '%node.js%' or @JobTitle Like '%node js%') then 'node js' 
		when (@JobTitle Like '% php %' ) then 'php' 
		when (@JobTitle Like '%javascript%' ) then 'javascript' 
		when (@JobTitle Like '%typescript%' ) then 'typescript' 
		when (@JobTitle Like '%jquery%' ) then 'javascript' 
		when (@JobTitle Like '%ASP.Net%' ) then 'ASP' 
		when (@JobTitle Like '%cold fusion%' ) then 'Cold Fusion' 
		when (@JobTitle Like '%PERL%' ) then 'PERL' 
		when (@JobTitle Like '%JSP%' ) then 'JSP' 
		when (@JobTitle Like '%arduino%' ) then 'arduino' 
		when (@JobTitle Like '%raspberry%' ) then 'raspberry' 
		when (@JobTitle Like '%VMware%' ) then 'VMware' 
		when (@JobTitle Like '%Lamp Stack%' ) then 'Lamp Stack' 
		when (@JobTitle Like '%mean Stack%' ) then 'Mean Stack' 
		when (@JobTitle Like '%mysql%' ) then 'mysql' 
		when (@JobTitle Like '%amazon EC2%' ) then 'amazon EC2' 
		when (@JobTitle Like '%nginx%' ) then 'nginx' 
		when (@JobTitle Like '%postgresql%' ) then 'postgresql' 
		when (@JobTitle Like '%HAProxy%' ) then 'HAProxy' 
		when (@JobTitle Like '%backbone.js%' ) then 'backbone.js' 
		when (@JobTitle Like '%elasticsearch%' ) then 'elasticsearch' 
		when (@JobTitle Like '%bootstrap%' ) then 'bootstrap' 
		when (@JobTitle Like '%C++%' ) then 'C++' 
		when (@JobTitle Like '%scala%' ) then 'scala' 
		when (@JobTitle Like '%spark%' ) then 'spark' 
		when (@JobTitle Like '%amazon redshift%' ) then 'amazon redshift' 
		when (@JobTitle Like '%amazon cloudshift%' ) then 'amazon cloudshift' 
		when (@JobTitle Like '%amazon route%' ) then 'amazon route 53' 
		when (@JobTitle Like '%AWS RDS%' ) then 'AWS RDS' 
		when (@JobTitle Like '%apache solr%' ) then 'apache solr' 
		when (@JobTitle Like '%apache kafka%' ) then 'apache kafka' 
		when (@JobTitle Like '%django%' ) then 'django' 
		when (@JobTitle Like '%apache zookeeper%' ) then 'Apache ZooKeeper' 
		when (@JobTitle Like '%Rabbit MQ%' ) then 'Rabbit MQ' 
		when (@JobTitle Like '%Webshphere%' ) then 'Webshphere' 
		when (@JobTitle Like '% SAP %' ) then 'SAP' 

	ELSE '' 
	End
	As Technology,
	(
		case 
		when (@JobTitle Like '% HR %' or @JobTitle Like '%Human Resource%'
		or @JobTitle Like '% HCM %'

		) then 'Human Resource' 
		when (@JobTitle Like '%ETRM%' or @JobTitle Like '%CTRM%') then 'ETRM' 
		when (@JobTitle Like '%treasury settlement%' ) then 'Treasury Settlement' 
			when (@JobTitle Like '%Enterprise Risk%' or @JobTitle Like '%ERM%' or
		@JobTitle Like '%risk governance%')  then 'Enterprise Risk' 
		when (@JobTitle Like '%fraud risk%' ) then 'fraud risk' 
		when (@JobTitle Like '%cyber security%' ) then 'Cyber Security' 
		when (@JobTitle Like '%mobile development%' or @JobTitle Like '%mobile application%') then 'Mobile'
		when (@JobTitle Like '%supply chain%' or @JobTitle Like '%demand plan%'
		or @JobTitle Like '%supply plan%'
		) then 'Supply Chain'
		
		when (@JobTitle Like '%Procurement%') then 'Procurement' 
		when (@JobTitle Like '% UX %') then 'UX' 
			when (@JobTitle Like '%sale%' or @JobTitle Like '%business development%') then 'sales' 
			when (@JobTitle Like '%customer relation%') then 'customer relation' 
		when (@JobTitle Like '%marketing automation%' or @JobTitle Like '%marketing data%'
		or @JobTitle Like '%marketing analytic%' or @JobTitle Like '%lead generation%'
		or @JobTitle Like '%inbound sale%' or @JobTitle Like '%inside sale%'
		or @JobTitle Like '%outbound sale%' or @JobTitle Like '%campaign manage%'
		or @JobTitle Like '%digital market%'
		) then 'Marketing Automation' 
		when (@JobTitle Like '%process improvement%') then 'Process improvement' 
		when (@JobTitle Like '%automation%' or @JobTitle Like '%RPA%') then 'Automation'
		when (@JobTitle Like '%advance analytic%' or @JobTitle Like '%predictive analytic%' or @JobTitle Like '%machine learn%' or @JobTitle Like '%deep learn%'
			 or @JobTitle Like '%artificial intelligence%' OR @JobTitle Like '%data analy%' OR @JobTitle Like '%data scien%' OR @JobTitle Like '(IoT)' OR @JobTitle Like ' (IoT) ' 
			 or @JobTitle Like '%optimiz%' or @JobTitle Like '%big data%'
			 or @JobTitle Like '%market research%' or @JobTitle Like '%analyst%'
			 ) then 'Analytics'
		when (@JobTitle Like '%Business Intelligence%' or @JobTitle Like '%Power BI%'
		or @JobTitle Like '%tableau%' or @JobTitle Like '%qlik%' or @JobTitle Like '%data visualization%'
		or @JobTitle Like '%analytic%' or @JobTitle Like '%reporting%' or @JobTitle Like '%decision support%'
		or @JobTitle Like '%BI %' or @JobTitle Like '%data min%'  ) then 'Business Intelligence' 				
		when (@JobTitle Like '%cloud%' or @JobTitle Like '%AWS%' or @JobTitle Like '%Azure%' ) then 'Cloud'
	ELSE '' 
	End------------Receptionist cum Office AssistantReceptionist cum Office Assistant
	)
	As Functionality,
	@company AS OrganizationName, @JobTitle as JobTitle, @summary as Summary

END
