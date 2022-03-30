/****** Object:  Procedure [dbo].[GenerateMarketingListInsights]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <08th Jan 2021>
-- Description:	<Generate insights for contact list>
-- =============================================
CREATE PROCEDURE [dbo].[GenerateMarketingListInsights] 
@MarketingListId int,
@Threshold int

/*

[dbo].[GenerateMarketingListInsights] 8181,0
'Percentage of decision makers in given seniority'
*/
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #report
	(
		Id int identity Primary key,
		InsightDetails varchar(250),
		EnglishAndNonEnglish varchar(100),
		TechnologyAndFunctionalityAndSeniority varchar(250),
		Insights varchar(250)
	)

	DECLARE @TotalAccounts int
	DECLARE @UserId int,@TargetPersonaId int
	DECLARE @ClientName VARCHAR(100)
	DECLARE @ClientEmail VARCHAR(100)

	SELECT @UserId = CreatedBy,@TargetPersonaId = TargetPersonaId FROM MarketingLists WHERE Id = @MarketingListId
	SELECT @ClientName = [Name], @ClientEmail = Email FROM AppUser WHERE Id = @UserId

	DECLARE @HasTechnology bit = (SELECT top 1 1 FROM UserTargetTechnology WHERE UserID = @UserId)
	SET @HasTechnology = IIF(@HasTechnology IS NULL,0,1)

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of accounts in contact list' as InsightDetails,
			COUNT(DISTINCT(l.OrganizationId)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
	WHERE	d.MarketingListId = @MarketingListId

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of countries in contact list' as InsightDetails,
			COUNT(DISTINCT(l.ResultantCountryId)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
	WHERE	d.MarketingListId = @MarketingListId

	INSERT INTO #report(InsightDetails,EnglishAndNonEnglish,Insights)
	SELECT 'Total No. of English and Non-English countries' as InsightDetails,
			CASE 
				WHEN 
					IsEnglishSpeaking = 1 
				THEN	
					'English'
				ELSE
					'Non-English'
			END as EnglishAndNonEnglish,
			Insights
	FROM
	(
		SELECT	c.IsEnglishSpeaking,
				COUNT(DISTINCT(l.ResultantCountryId)) as Insights
		FROM	DecisionMakersForMarketingList d
				INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
				INNER JOIN Country c ON (c.Id = l.ResultantCountryId)
		WHERE	d.MarketingListId = @MarketingListId
				--AND c.IsEnglishSpeaking = 1
		GROUP BY c.IsEnglishSpeaking
	)e
	ORDER BY 3 DESC

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of industries in contact list' as InsightDetails,
			COUNT(DISTINCT(o.IndustryId)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN Organization o ON (l.OrganizationId = o.Id)
			INNER JOIN Industry i ON (i.Id = o.IndustryId)
	WHERE	d.MarketingListId = @MarketingListId

	-- Calculate Percentage of technologies START

	SELECT	@TotalAccounts = COUNT(DISTINCT(l.OrganizationId))
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
	WHERE	d.MarketingListId = @MarketingListId

	INSERT INTO #report(InsightDetails,TechnologyAndFunctionalityAndSeniority,Insights)
	SELECT	'Percentage of companies with configured technologies' as InsightDetails,
			t.Keyword as Technology,
			ROUND(CONVERT(FLOAT,(COUNT(DISTINCT(l.OrganizationId)) * 100)) / 
			CONVERT(FLOAT,@TotalAccounts),3) as Percentage
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId = l.Id)
			INNER JOIN Technographics t ON (t.OrganizationId = l.OrganizationId)
	WHERE	d.MarketingListId = @MarketingListId
			AND (
					@HasTechnology = 0 OR 
						t.Keyword IN
					(
						SELECT Technology FROM UserTargetTechnology WHERE UserID = @UserId
					)
				)
	GROUP BY t.Keyword
	ORDER BY 3 DESC

	-- Calculate Percentage of technologies END

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of companies with high spending intent' as InsightDetails,
			COUNT(DISTINCT(o.Id)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN Organization o ON (l.OrganizationId = o.Id)
			INNER JOIN SurgeSummary s ON (s.OrganizationId = o.Id)
	WHERE	d.MarketingListId = @MarketingListId
			AND s.SpendEstimate IN ('Extreme High','High','Very High')
			AND s.Functionality IN 
			(SELECT Functionality FROM UserTargetFunctionality WHERE UserID = @UserId)
			AND s.CountryID IN 
			(SELECT CountryId FROM UserTargetCountry WHERE UserID = @UserId)
			AND (
					@HasTechnology = 0 OR
					s.Technology IN 
					(SELECT Technology FROM UserTargetTechnology WHERE UserId = @UserId)
				)

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. Decision Makers whose country location is different from company headquarters' as InsightDetails,
			COUNT(DISTINCT(l.Id)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN Organization o ON (l.OrganizationId = o.Id )
	WHERE	d.MarketingListId = @MarketingListId
			AND o.CountryId <> l.ResultantCountryId
			--AND NOT EXISTS
			--(SELECT * FROM Organization org WHERE org.CountryId = l.ResultantCountryId)

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. Decision Makers' as InsightDetails,
			COUNT(DISTINCT(l.Id)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
	WHERE	d.MarketingListId = @MarketingListId
	
	INSERT INTO #report(InsightDetails,Insights)
	SELECT 'Average No. of Decision Makers Per account' as InsightDetails,
		   AVG(Insights) as Average FROM (
	SELECT	o.Id as OrganizationId,
			COUNT(DISTINCT(l.Id)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN Organization o ON (l.OrganizationId = o.Id )
	WHERE	d.MarketingListId = @MarketingListId
	GROUP BY o.Id)a

	INSERT INTO #report(InsightDetails,TechnologyAndFunctionalityAndSeniority,Insights)
	SELECT	'Percentage of decision makers in given functionality' as InsightDetails,
			m.Name as Functionality,
			ROUND(CONVERT(FLOAT,(COUNT(Distinct(l.id)) * 100)) / 
			CONVERT(FLOAT,(SELECT COUNT(DISTINCT(l.Id))
						   FROM	DecisionMakersForMarketingList d
			               INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
						   WHERE d.MarketingListId = @MarketingListId)),3) as Percentage
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN McDecisionmakerlist m ON (l.id = m.DecisionMakerId )
	WHERE	d.MarketingListId = @MarketingListId
			--AND m.Name IN (SELECT Functionality FROM UserTargetFunctionality WHERE UserID = @UserId)
	GROUP BY m.Name
	ORDER BY 3 DESC

	INSERT INTO #report(InsightDetails,TechnologyAndFunctionalityAndSeniority,Insights)
	SELECT	'Percentage of decision makers in given seniority' as InsightDetails,
			l.SeniorityLevel as Seniority,
			ROUND(CONVERT(FLOAT,(COUNT(Distinct(l.id)) * 100)) / 
			CONVERT(FLOAT,(SELECT COUNT(DISTINCT(l.Id))
						   FROM	DecisionMakersForMarketingList d
			               INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
						   WHERE d.MarketingListId = @MarketingListId)),3) as Percentage
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
	WHERE	d.MarketingListId = @MarketingListId
	GROUP BY l.SeniorityLevel
	ORDER BY 3 DESC

	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of companies where lead score is above threshold score' as InsightDetails,
		    COUNT(DISTINCT(l.OrganizationId)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN TargetPersonaOrganization t ON (l.OrganizationId = t.OrganizationId)
	WHERE	d.MarketingListId = @MarketingListId
			AND t.TargetPersonaId = @TargetPersonaId
			AND t.LeadScore > @Threshold
	
	INSERT INTO #report(InsightDetails,Insights)
	SELECT	'Total No. of EmployeeCount Range' as InsightDetails,
			COUNT(DISTINCT(o.EmployeeCount)) as Insights
	FROM	DecisionMakersForMarketingList d
			INNER JOIN LinkedInData l ON (d.DecisionMakerId=l.Id)
			INNER JOIN Organization o ON (l.OrganizationId = o.Id)
	WHERE	d.MarketingListId = @MarketingListId

	-- Added by Asef on 26th May 2021
	INSERT INTO #report(InsightDetails, TechnologyAndFunctionalityAndSeniority, Insights)
	SELECT top 1 'Highest Percentage of decision makers in given functionality' as InsightDetails,
		r.TechnologyAndFunctionalityAndSeniority,
		r.Insights
	FROM #report r
		where r.Insights = (select max(cast(insights as float)) from #report where InsightDetails = 'Percentage of decision makers in given functionality')

	INSERT INTO #report(InsightDetails, TechnologyAndFunctionalityAndSeniority, Insights)
	SELECT top 1 'Highest Percentage of decision makers in given seniority' as InsightDetails,
		r2.TechnologyAndFunctionalityAndSeniority,
		r2.Insights
	FROM #report r2
		where r2.Insights = (select max(cast(insights as float)) from #report where InsightDetails = 'Percentage of decision makers in given seniority')
		and r2.InsightDetails = 'Percentage of decision makers in given seniority'

	INSERT INTO #report(InsightDetails, TechnologyAndFunctionalityAndSeniority)
	SELECT 'ClientName',
	@ClientName

	INSERT INTO #report(InsightDetails, TechnologyAndFunctionalityAndSeniority)
	SELECT 'TargetPersonaId',
	@TargetPersonaId

	INSERT INTO #report(InsightDetails, TechnologyAndFunctionalityAndSeniority)
	SELECT 'ClientEmail',
	@ClientEmail
------------------------
	--select min(insights) from #report where InsightDetails = 'Percentage of decision makers in given seniority'

    SELECT * FROM #report ORDER BY Id

	DROP TABLE #report
END
