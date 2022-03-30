/****** Object:  View [dbo].[SignalList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[SignalList]
AS


WITH CTE AS
(
SELECT TagId,  TagName, DisplayName,IndustryId,COUNT(1) as num 
FROM
(
SELECT DISTINCT T.id as TagId,T.Name AS tagName,RFS.IndustryId as industryId, S.DisplayName, datepart(qq, RF.PubDate) as  NewsQuarter
						
FROM            dbo.RssFeedItemSignal AS RFS
                         INNER JOIN dbo.RssFeedItem AS RF ON RFS.RssFeedItemId = RF.Id 
						 INNER JOIN dbo.Tag AS T ON RFS.TagId = T.Id and T.TagTypeId = 1
						 INNER JOIN dbo.Organization AS O ON O.Id = T.OrganizationId and O.IsActive = 1
						 INNER JOIN dbo.Industry AS I ON RFS.IndustryId = I.Id INNER JOIN
                         dbo.Signal AS S ON RFS.SignalId = S.Id INNER JOIN
                         dbo.IndustryTag ON T.Id = dbo.IndustryTag.TagId AND I.Id = dbo.IndustryTag.IndustryId
						 WHERE RF.PubDate>=DATEADD(qq, DATEDIFF(qq,0,DATEADD(qq,-3,getdate())), 0)
) S 
--WHERE tagName='Adam'
GROUP By TagId, TagName, DisplayName ,IndustryId
)
--select * FROM cte
, CTE1 AS
(
SELECT DISTINCT CTE.*,
CASE WHEN CTE.num=4  THEN 'Consistent' 
	WHEN CTE.num=3  THEN 'Frequent' 
	WHEN CTE.num=2  THEN 'Occasional'
WHEN CTE.num=1 AND datepart(qq, getdate())= tb.News_Quarter THEN 'Bubbling Up' 
WHEN CTE.num=1 AND datepart(qq, getdate())<> tb.News_Quarter THEN 'Rare' 
ELSE '' END As Signal_Frequency 

FROM CTE 
INNER JOIN
(
	SELECT   DISTINCT T.id as TagId,T.Name AS tagName, RFS.IndustryId as industryId,S.DisplayName, datepart(qq, RF.PubDate)  AS News_Quarter, COUNT(S.DisplayName) as Num
FROM            dbo.RssFeedItemSignal AS RFS
                         INNER JOIN dbo.RssFeedItem AS RF ON RFS.RssFeedItemId = RF.Id 
						 INNER JOIN dbo.Tag AS T ON RFS.TagId = T.Id and T.TagTypeId = 1
						 INNER JOIN dbo.Organization AS O ON O.Id = T.OrganizationId and O.IsActive = 1
						 INNER JOIN dbo.Industry AS I ON RFS.IndustryId = I.Id INNER JOIN
                         dbo.Signal AS S ON RFS.SignalId = S.Id INNER JOIN
                         dbo.IndustryTag ON T.Id = dbo.IndustryTag.TagId AND I.Id = dbo.IndustryTag.IndustryId
						 WHERE RF.PubDate>=DATEADD(qq, DATEDIFF(qq,0,DATEADD(qq,-3,getdate())), 0) 
		GROUP By T.id,T.Name,S.DisplayName, datepart(qq, RF.PubDate),RFS.IndustryId
) as tb ON CTE.TagName=tb.tagName AND cte.DisplayName=tb.DisplayName

)
--select * from CTE1

SELECT * FROM (
	select  ROW_NUMBER() OVER(order BY TN2.TagName  + TN2.Signal_Frequency) AS ID ,TN2.TagId, TN2.TagName, TN2.industryId ,TN2.Signal_Frequency,COUNT(TN2.DisplayName) AS NoOfSignals,
	STUFF((select distinct ',' + TN1.DisplayName
	from CTE1 TN1
	where 
	     TN2.industryId=TN1.industryId
		and TN2.TagName = TN1.TagName
		and TN2.Signal_Frequency = TN1.Signal_Frequency 
		FOR XML PATH('')),1,1,'') AS DisplayName
		from CTE1 TN2
		group by TN2.TagId,TN2.TagName, TN2.Signal_Frequency,TN2.industryId
		) AS S --WHERE NoOfSignalWords>1




--, CTE2
--AS
--(
--SELECT DISTINCT RF.ID,T.Name AS tagName, S.DisplayName, 
--CASE WHEN ISNULL(RF.PubDate, 
--                         '2016-09-30') <= '2016-09-30 23:59:59' THEN '2016-Q3 or Before' ELSE CAST(year(RF.PubDate) AS char(4)) + '-Q' + CAST(CEILING(CAST(month(RF.PubDate) AS decimal(4, 2)) / 3) AS char(1)) END AS newsQuarter
----INTO #temp						
--FROM            dbo.RssFeedItemSignal AS RFS
--                         INNER JOIN dbo.RssFeedItem AS RF ON RFS.RssFeedItemId = RF.Id 
--						 INNER JOIN dbo.Tag AS T ON RFS.TagId = T.Id and T.TagTypeId = 1
--						 INNER JOIN dbo.Organization AS O ON O.Id = T.OrganizationId and O.IsActive = 1
--						 INNER JOIN dbo.Industry AS I ON RFS.IndustryId = I.Id INNER JOIN
--                         dbo.Signal AS S ON RFS.SignalId = S.Id INNER JOIN
--                         dbo.IndustryTag ON T.Id = dbo.IndustryTag.TagId AND I.Id = dbo.IndustryTag.IndustryId
--						 WHERE S.SignalRssType IN (1,3)
--)
--,CTE3
--AS
--(
--SELECT tagName, DisplayName,NoOfSignalWords,'More than one signal' Signal_Frequency  FROM 
--(
--	select TN2.ID AS RssFeedItemId, TN2.tagName, TN2.newsQuarter,COUNT(TN2.DisplayName) AS NoOfSignalWords,
--	STUFF((select distinct ',' + TN1.DisplayName
--	from CTE2 TN1
--	where 
--		TN2.ID = TN1.ID
--		and TN2.tagName = TN1.tagName 
--		and TN2.newsQuarter = TN1.newsQuarter 
--		FOR XML PATH('')),1,1,'') AS DisplayName	
--		from CTE2 TN2
--		group by TN2.ID, TN2.tagName, TN2.newsQuarter
--		) AS S WHERE NoOfSignalWords>1
--		--Order By  	RssFeedItemId,tagName,newsQuarter
--)

--select * from cte1
--UNION all
--select * from cte3

--DROP TABLE #temp
