/****** Object:  Procedure [dbo].[GetCampaignReportAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <27th Jan 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[GetCampaignReportAnalysis]
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
			m.DecisionMakerId,
			m.Name
			into #tempFunctionality
	FROM	SurgeContactDetail s
			INNER JOIN LinkedInData l ON (s.Url = l.Url)
			INNER JOIN McDecisionMakerList m ON (l.Id = m.DecisionMakerId)
	WHERE	m.Name IN
			(SELECT Functionality FROM UserTargetFunctionality WHERE UserId = @UserId)
			AND s.EmailId IN
			(SELECT value FROM STRING_SPLIT(@keyword,','))
			AND s.UserId = @UserId


	SELECT	DISTINCT
			l.Id,
			l.FirstName,
			l.MiddleName,
			l.LastName,
			l.Name,
			s.EmailId,
			l.Designation as Title,
			l.SeniorityLevel,
			o.Name as Organization,
			o.WebsiteUrl,
			i.Name as Industry,
			c.Name as HeadQuarter,
			o.EmployeeCount,
			o.Revenue,
			STRING_AGG(t.Keyword,',') AS Technology,
			--STRING_AGG(m.Name,',') AS Teams
			m.Name as Teams into #aggProfiles
	FROM	SurgeContactDetail s
			INNER JOIN LinkedInData l ON (s.Url = l.Url)
			INNER JOIN #tempFunctionality m ON (l.Id = m.DecisionMakerId)
			INNER JOIN Organization o ON (o.Id = l.OrganizationId)
			INNER JOIN Industry i ON (i.Id = o.IndustryId)
			INNER JOIN Country c ON (o.CountryId = c.Id)
			LEFT JOIN #temptechnology t ON (t.OrganizationId = o.Id)
	WHERE	s.EmailId IN
			(SELECT value FROM STRING_SPLIT(@keyword,','))
			AND s.UserId = @UserId
	GROUP BY
			l.Id,
			l.FirstName,
			l.MiddleName,
			l.LastName,
			l.Name,
			s.EmailId,
			l.Designation,
			l.SeniorityLevel,
			o.Name,
			o.WebsiteUrl,
			i.Name,
			c.Name,
			o.EmployeeCount,
			o.Revenue,
			m.Name


	SELECT *,len(Technology) - len(replace(Technology, ',', ''))+1 as NoOfTechnologies
		FROM(		
		SELECT	DISTINCT
				FirstName,
				MiddleName,
				LastName,
				Name,
				EmailId,
				Title,
				SeniorityLevel,
				Organization,
				WebsiteUrl,
				Industry,
				HeadQuarter,
				EmployeeCount,
				Revenue,
				Technology,
				REPLACE(REPLACE(STUFF(
				(SELECT ', ' + [Name]
				FROM (SELECT DISTINCT [Name]
					FROM
						#tempFunctionality f
					WHERE f.decisionmakerid = p.Id) mc2
				FOR XML PATH ('')
				)
				, 1, 1, ''), '&amp;', '&'), '''', '') AS Functionality
		from #aggProfiles p	
		)t
		
			
    DROP TABLE #temptechnology
	DROP TABLE #tempFunctionality
	DROP TABLE #aggProfiles
END
