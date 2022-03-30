/****** Object:  View [dbo].[SummarizedJobInsights]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SummarizedJobInsights]
AS


WITH CTESIgnalType1
AS
(
SELECT DISTINCT o.tagName, S.DisplayName , S.SignalRssType, newsQuarter, JB.joblocation, JB.jobtitle,o.IndustryId						
FROM            [dbo].[OutputIndustrySignalAnalysis]  o
						INNER JOIN  dbo.RssFeedItemSignal AS RFS ON RFS.RssFeedItemId=o.RssFeedItemId
                        INNER JOIN  dbo.Signal AS S ON RFS.SignalId = S.Id
						INNER join dbo.rssfeeditem RF on O.rssfeeditemid = RF.id
						INNER join dbo.jobposting JB on RF.link collate SQL_Latin1_General_CP1_CI_AS = JB.joburl
						WHERE S.SignalRssType=3--IN (1,3)
						and S.id in (72, 73, 74)
						-- and o.RssFeedItemId=4098689
)
,CTE3
AS
(
SELECT IndustryId,tagName, DisplayName + ' Hiring '+ CASE WHEN newsQuarter=CAST(YEAR(getdate()) AS char(4))+'-Q'+ CAST(datepart(qq, getdate()) AS VARCHAR) THEN '- Current Quarter'
				ELSE '-Previous Quarter' END as SignalName,SignalRssType,NoOfSignalWords, JobTitles FROM 
(
	select  TN2.IndustryId,TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
	STUFF((select distinct ',' + TN1.jobtitle
	from CTESIgnalType1 TN1
	where 
		TN2.DisplayName = TN1.DisplayName
		and TN2.tagName = TN1.tagName 
		and TN2.newsQuarter = TN1.newsQuarter 
		FOR XML PATH('')),1,1,'') AS JobTitles	
		from CTESIgnalType1 TN2
		group by TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,TN2.IndustryId
		) AS S --WHERE NoOfSignalWords>1
		
)

,CTE4
AS
(
SELECT IndustryId,tagName, DisplayName  + ' Location' as SignalName,SignalRssType,NoOfSignalWords, JobLocations FROM 
(
	select TN2.IndustryId, TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
	STUFF((select distinct ',' + TN1.JobLocation
	from CTESIgnalType1 TN1
	where 
		TN2.DisplayName = TN1.DisplayName
		and TN2.tagName = TN1.tagName 
		and TN2.newsQuarter = TN1.newsQuarter 
		FOR XML PATH('')),1,1,'') AS JobLocations	
		from CTESIgnalType1 TN2
		group by TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,TN2.IndustryId
		) AS S --WHERE NoOfSignalWords>1
		
)

--SELECT * FROM CTE4

select *
  from CTE3
  union
  select * from CTE4
