/****** Object:  View [dbo].[SummarizedInsights]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SummarizedInsights]
AS

--select * from Signal
--select * from RssFeedItemSignal
--WHERE  RssFeedItemId=4150724
--select DISTINCT o.RssFeedItemId,o.tagName, o.DisplayName from OutputIndustrySignalAnalysis o where  RssFeedItemId=4150724

WITH CTESIgnalType1
AS
(
SELECT DISTINCT o.RssFeedItemId,o.tagName, S.DisplayName, S.SignalRssType, newsQuarter						
FROM            [dbo].[OutputIndustrySignalAnalysis]  o
						INNER JOIN  dbo.RssFeedItemSignal AS RFS ON RFS.RssFeedItemId=o.RssFeedItemId
                        INNER JOIN  dbo.Signal AS S ON RFS.SignalId = S.Id
						WHERE S.SignalRssType=1 --IN (1,3)
						-- and o.RssFeedItemId=4098689
)
,CTE3
AS
(
SELECT RssFeedItemId,tagName, DisplayName,SignalRssType,NoOfSignalWords FROM 
(
	select TN2.RssFeedItemId, TN2.tagName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
	STUFF((select distinct ',' + TN1.DisplayName
	from CTESIgnalType1 TN1
	where 
		TN2.RssFeedItemId = TN1.RssFeedItemId
		and TN2.tagName = TN1.tagName 
		and TN2.newsQuarter = TN1.newsQuarter 
		FOR XML PATH('')),1,1,'') AS DisplayName	
		from CTESIgnalType1 TN2
		group by TN2.RssFeedItemId, TN2.tagName, TN2.newsQuarter,TN2.SignalRssType
		) AS S --WHERE NoOfSignalWords>1
		
)

--select * from CTE3
, CTESIgnalType3
AS
(
	SELECT DISTINCT o.RssFeedItemId,o.tagName, S.DisplayName, S.SignalRssType, newsQuarter						
FROM            [dbo].[OutputIndustrySignalAnalysis]  o
						INNER JOIN  dbo.RssFeedItemSignal AS RFS ON RFS.RssFeedItemId=o.RssFeedItemId
                        INNER JOIN  dbo.Signal AS S ON RFS.SignalId = S.Id
						 WHERE S.SignalRssType=3 
						 --and o.RssFeedItemId=4098689
)
, CTE4 AS
(
SELECT RssFeedItemId,tagName, DisplayName,SignalRssType,NoOfSignalWords  FROM 
(
	select TN2.RssFeedItemId, TN2.tagName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
	STUFF((select distinct ',' + TN1.DisplayName
	from CTESIgnalType3 TN1
	where 
		TN2.RssFeedItemId = TN1.RssFeedItemId
		and TN2.tagName = TN1.tagName 
		and TN2.newsQuarter = TN1.newsQuarter 
		FOR XML PATH('')),1,1,'') AS DisplayName	
		from CTESIgnalType3 TN2
		group by TN2.RssFeedItemId, TN2.tagName, TN2.newsQuarter,TN2.SignalRssType
		) AS S --WHERE NoOfSignalWords>1
)

--SELECT * FROM CTE4

select DISTINCT s1.RssFeedItemId,s3.DisplayName+','+s1.DisplayName AS DisplayName ,s1.NoOfSignalWords+s3.NoOfSignalWords AS NoOfSignalWords
,
RegionName,
ContinentName,
CountryName,
IndustryId,
tagId,
o.tagName,
SignalWord,
newsQuarter,
Title,
Link,
PubDate,
ScoreDate
  from CTE3 s1 inner join CTE4 s3 ON s1.RssFeedItemId=s3.RssFeedItemId AND  s1.tagName=s3.tagName 
  INNER JOIN   [dbo].[OutputIndustrySignalAnalysis]  o ON o.RssfeedItemId=s1.RssFeedItemId
