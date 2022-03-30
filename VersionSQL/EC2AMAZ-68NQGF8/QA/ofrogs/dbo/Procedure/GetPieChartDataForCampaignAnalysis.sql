/****** Object:  Procedure [dbo].[GetPieChartDataForCampaignAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <28th Jan 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE GetPieChartDataForCampaignAnalysis
@keyword varchar(MAX),
@UserId int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT
			Keyword,
			OrganizationId  
			into #temptechnology
	FROM	Technographics
	WHERE	keyword IN (SELECT Technology FROM UserTargetTechnology WHERE UserId = @UserId)


	SELECT	DISTINCT
			t.Keyword,
			Count(DISTINCT(o.Id)) as CompanyOccurrences,
			Count(o.Id) as PersonOccurrences
	FROM	SurgeContactDetail s
			INNER JOIN LinkedInData l ON (s.Url = l.Url)
			INNER JOIN Organization o ON (o.Id = l.OrganizationId)
			INNER JOIN Country c ON (o.CountryId = c.Id)
			INNER JOIN #temptechnology t ON (t.OrganizationId = o.Id)
	WHERE	s.EmailId IN
			(SELECT value FROM STRING_SPLIT(@keyword,','))
			AND s.UserId = @UserId
	GROUP BY
			t.Keyword
    
END
