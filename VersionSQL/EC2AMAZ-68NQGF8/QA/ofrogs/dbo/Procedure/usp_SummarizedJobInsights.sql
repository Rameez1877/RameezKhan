/****** Object:  Procedure [dbo].[usp_SummarizedJobInsights]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE usp_SummarizedJobInsights
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		SELECT DISTINCT o.tagName, S.DisplayName , S.SignalRssType, newsQuarter, JB.joblocation, JB.jobtitle	INTO #temp					
		FROM            [dbo].[OutputIndustrySignalAnalysis]  o
								INNER JOIN  dbo.RssFeedItemSignal AS RFS ON RFS.RssFeedItemId=o.RssFeedItemId
								INNER JOIN  dbo.Signal AS S ON RFS.SignalId = S.Id
								INNER join dbo.rssfeeditem RF on O.rssfeeditemid = RF.id
								INNER join dbo.jobposting JB on RF.link collate SQL_Latin1_General_CP1_CI_AS = JB.joburl
								WHERE S.SignalRssType=3--IN (1,3)
								and S.id in (72, 73, 74)
								-- and o.RssFeedItemId=4098689


		SELECT tagName, DisplayName + ' Hiring' + CASE WHEN newsQuarter=CAST(YEAR(getdate()) AS char(4))+'-Q'+ CAST(datepart(qq, getdate()) AS VARCHAR) THEN '-Current Quarter'
				ELSE '-Previous Quarter' END
		 as SignalName,newsQuarter,SignalRssType,NoOfSignalWords, JobTitles FROM 
		(
			select  TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
			STUFF((select distinct ',' + TN1.jobtitle
			from #temp TN1
			where 
				TN2.DisplayName = TN1.DisplayName
				and TN2.tagName = TN1.tagName 
				and TN2.newsQuarter = TN1.newsQuarter 
				FOR XML PATH('')),1,1,'') AS JobTitles	
				from #temp TN2
				group by TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType
				) AS S --WHERE NoOfSignalWords>1
	
			UNION 	

		SELECT tagName, DisplayName  + 'Location' as SignalName,newsQuarter,SignalRssType,NoOfSignalWords, JobLocations FROM 
		(
			select  TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType,COUNT(TN2.DisplayName) AS NoOfSignalWords,
			STUFF((select distinct ',' + TN1.JobLocation
			from #temp TN1
			where 
				TN2.DisplayName = TN1.DisplayName
				and TN2.tagName = TN1.tagName 
				and TN2.newsQuarter = TN1.newsQuarter 
				FOR XML PATH('')),1,1,'') AS JobLocations	
				from #temp TN2
				group by TN2.tagName, TN2.DisplayName, TN2.newsQuarter,TN2.SignalRssType
				) AS S --WHERE NoOfSignalWords>1	

END
