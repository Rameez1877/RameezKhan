/****** Object:  Procedure [dbo].[AnalyzeJobsDataIndeed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AnalyzeJobsDataIndeed]
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
	DECLARE @endpos INT = CHARINDEX(' - ',REVERSE(@localstring)) + 3

	--'AW ,ecarreT ekaltnuoM - Get the location of job in reversed string
	DECLARE @jobLocation NVARCHAR(1000) = REVERSE(SUBSTRING(REVERSE(@localstring), 1, @endpos-3))

	--PLL ,eleetS & xandorB ,eveiZ - lagelaraP -- Removes the last word in the string
	DECLARE @newlocalstring NVARCHAR(1000) = REVERSE(LEFT(@localstring, len(@localstring)-@endpos+1))

	--Zieve, Brodnax & Steele, LLP .........Get the first part of shortenend reverse string which is OrganizationName
	DECLARE @newendpos INT = CHARINDEX(' - ',@newlocalstring)-1
	DECLARE @OrgName NVARCHAR(1000) = REVERSE(SUBSTRING(@newlocalstring, 1, @newendpos)) 

	--Paralegal .........Get the second part of shortenend reverse string which is JobTitle details
	DECLARE @JobTitle NVARCHAR(1000) = REVERSE(SUBSTRING(@newlocalstring, @newendpos+4,Len(@newlocalstring)-@newendpos-3)) 

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

		when (@JobTitle like '%openspan%'
				 or @JobTitle like '%UIPath%' or @JobTitle like '% blue prism%' 
				 or @JobTitle like '%automation anywhere%') then 'RPA Tool'

		when (@JobTitle Like '% HR %' or @JobTitle Like '%Human Resource%'
		or @JobTitle Like '% HCM %' ) then 'Human Resource' 
		when (@JobTitle Like '%microsoft bi%'  or @JobTitle Like '%power bi%' 
		or @JobTitle Like '%SSIS %' or @JobTitle Like '%SSAS %' OR @JobTitle Like '%powerbi%') then 'Microsoft BI' 
		when (@JobTitle Like '%Tableau%' ) then 'Tableau' 
		when (@JobTitle Like '%Qlik%' ) then 'Qlikview'
		when (@JobTitle Like '%GoGo%' ) then 'GoGo'
		when (@JobTitle Like '%android%') then 'Android' 
		when (@JobTitle Like '%informatica%') then 'Informatica'
		when (@JobTitle Like '%Oracle HCM%' or @JobTitle Like '%Oracle Fusion') then 'Oracle HCM'
		
		when (@JobTitle Like '%success factor%') then 'HR Successfactor'
		when (@JobTitle Like '%Oracle%') then 'Oracle' 			
		when (@JobTitle Like '%.Net%') then 'Net' 				
		when (@JobTitle Like '%.Java%') then 'Java' 			
			when (@JobTitle Like '%C#%') then 'C Sharp' 
			when (@JobTitle Like '% VB %') then 'Visual Basic' 
			when (@JobTitle Like '%python%') then 'Python' 				
		when (@JobTitle Like '%Azure%') then 'Azure' 	
		when (@JobTitle Like '%AngularJS%') then 'Angular'
		when (@JobTitle Like '%MongoDB%') then 'MongoDB'
		when (@JobTitle Like '% AWS %' or @JobTitle Like '%Amazon Web Service%' ) then 'AWS' 		
		when (@JobTitle Like '%DHTML%') then 'DHTML' 
		when (@JobTitle Like 'AJAX') then 'AJAX' 		
		when (@JobTitle Like '%silverlight%') then 'silverlight' 			
		when (@JobTitle Like '%salesforce%' ) then 'salesforce' 
		when (@JobTitle Like '%marketo%' ) then 'marketo' 
		when (@JobTitle Like '%Ruby on rail%' or @JobTitle Like '%Ruby%') then 'Ruby on rail' 
		when (@JobTitle Like '%node.js%' or @JobTitle Like '%node js%') then 'node js' 
		when (@JobTitle Like '% php %' ) then 'php' 
		when (@JobTitle Like '%javascript%' ) then 'javascript' 
		when (@JobTitle Like '%typescript%' ) then 'typescript' 
		when (@JobTitle Like '%jquery%' ) then 'jquery' 
		when (@JobTitle Like '%arduino%' ) then 'arduino' 
		when (@JobTitle Like '%raspberry%' ) then 'raspberry' 
		when (@JobTitle Like '%VMware%' ) then 'VMware' 
				when (@JobTitle Like '%Lamp Stack%' ) then 'Lamp Stack' 
		when (@JobTitle Like '%mean Stack%' ) then 'Mean Stack' 
				when (@JobTitle Like '%PERL%' ) then 'PERL' 
		when (@JobTitle Like '%JSP%' ) then 'JSP' 
		when (@JobTitle Like '%arduino%' ) then 'arduino' 
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
		case when
		 (@JobTitle like '%RPA%' or @JobTitle like '%business process automation%' 
				 or @JobTitle like '%process automation%'
				 or @JobTitle like '%robotic automation%' or @JobTitle like '%robotics automation%'
				 or @JobTitle like '%RPA COE%' or @JobTitle like '%process improvement%'
				 or @JobTitle like '%intelligent automation%' ) then 'RPA'

		when (@JobTitle Like '%maintenance planning%' or 
		@JobTitle Like '%scheduling%') then 'Planning and Scheduling' 
		when (@JobTitle Like '%cyber security%' ) then 'Cyber Security' 
		when (@JobTitle Like '% UX %') then 'UX' 
		when (@JobTitle Like '%ETRM%' or @JobTitle Like '%CTRM%') then 'ETRM' 
		when (@JobTitle Like '%treasury settlement%' ) then 'Treasury Settlement' 
		when (@JobTitle Like '%Enterprise Risk%' or @JobTitle Like '%ERM%' or
		@JobTitle Like '%risk governance%')  then 'Enterprise Risk' 
		when (@JobTitle Like '%fraud risk%' ) then 'fraud risk' 
		when (@JobTitle Like '%mobile development%' or @JobTitle Like '%mobile application%') then 'Mobile'
		when (@JobTitle Like '%supply chain%' or @JobTitle Like '%demand plan%'
		or @JobTitle Like '%supply plan%'
		) then 'Supply Chain'
			when (@JobTitle Like '%customer relation%') then 'customer relation' 
		when (@JobTitle Like '%marketing automation%' or @JobTitle Like '%marketing data%'
		or @JobTitle Like '%marketing analytic%' or @JobTitle Like '%lead generation%'
		or @JobTitle Like '%inbound sale%' or @JobTitle Like '%inside sale%'
		or @JobTitle Like '%outbound sale%' or @JobTitle Like '%campaign manage%'
		or @JobTitle Like '%digital market%'
		) then 'Marketing Automation' 
		when (@JobTitle Like '%sale%' or @JobTitle Like '%business development%') then 'sales' 
		when (@JobTitle Like '%Procurement%') then 'Procurement' 
	--	when (@JobTitle Like '%marketing data%') then 'Marketing Automation' 
		when (@JobTitle Like '%process improvement%') then 'Process improvement' 
		when (@JobTitle Like '%automation%' or @JobTitle Like '%RPA%') then 'Automation'
			when (@JobTitle Like '%microsoft bi%'  or @JobTitle Like '%power bi%' 
		or @JobTitle Like '%SSIS %' or @JobTitle Like '%SSAS %' OR @JobTitle Like '%powerbi%' or
		 @JobTitle Like '%Tableau%' or @JobTitle Like '%Qlik%' or 
		@JobTitle Like '%advance analytic%' or @JobTitle Like '%predictive analytic%' or @JobTitle Like '%machine learn%' or @JobTitle Like '%deep learn%'
			 or @JobTitle Like '%artificial intelligence%' OR @JobTitle Like '%data analy%' OR @JobTitle Like '%data scien%' OR @JobTitle Like '%IoT%' 
			  or @JobTitle Like '%market research%' or @JobTitle Like '%analyst%'
			 or @JobTitle Like '%optimiz%' or @JobTitle Like '%big data%') then 'Analytics'
		when (@JobTitle Like '%Business Intelligence%' or @JobTitle Like '%Power BI%'
		or @JobTitle Like '%tableau%' or @JobTitle Like '%qlik%' or @JobTitle Like '%data visualization%'
		or @JobTitle Like '%analytic%' or @JobTitle Like '%reporting%' 
		or @JobTitle Like '%decision support%'
		or @JobTitle Like '%BI %' or @JobTitle Like '%data min%'  ) then 'Business Intelligence' 				
		when (@JobTitle Like '%cloud%' or @JobTitle Like '%AWS%' or @JobTitle Like '%Azure%' ) then 'Cloud'
	ELSE '' 
	End------------Receptionist cum Office AssistantReceptionist cum Office Assistant
	)
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
