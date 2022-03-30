/****** Object:  Procedure [dbo].[PopulateLastMonthIntent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <04th,Nov,2020>
-- Description:	<Populate last one month intent data>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateLastMonthIntent]
@UserId int,
@Count int
AS
BEGIN
	SET NOCOUNT ON;
	-- If user has configured technology display technology + functionality else functionality
	DECLARE @HasTechnology bit = (SELECT top 1 1 FROM UserTargetTechnology WHERE UserID = @UserId)
	SET @HasTechnology = IIF(@HasTechnology IS NULL,0,1)

	--DECLARE @Count int = 10

	Create Table #report
	(
		CountryName varchar(100),
		Organization varchar(150),
		OrganizationId int,
		Technology varchar(150),
		TechnologyCategory varchar(150),
		DecisionMaker varchar(150),
		Designation varchar(500),
		Url varchar(500),
		Age int--,
		--UserId int
	)

		INSERT INTO #report
		SELECT	TOP (@Count)
				s.CountryName,
				s.Organization,
				s.OrganizationId,
				s.Technology,
				s.TechnologyCategory,
				l.Name as DecisionMaker,
				trim(l.Designation) as Designation,
				l.Url,
				s.Duration as Age--,
				--uf.UserId
		FROM	SurgeSummary s WITH (NOLOCK)
				Inner Join LinkedInData l WITH (NOLOCK)
				ON (l.OrganizationId = s.OrganizationId and s.CountryId = l.ResultantCountryId)
				Inner Join McDecisionMakerList m WITH (NOLOCK)
				ON (l.Id = m.DecisionMakerId and s.Functionality = m.Name)
				--Inner Join UserTargetFunctionality uf
				--ON (s.Functionality = uf.Functionality)
				--Inner Join UserTargetTechnology ut
				--ON (s.Technology = ut.Technology)
				--Inner Join UserTargetCountry uc
				--ON (s.CountryId = uc.CountryId)
		WHERE	s.Duration IN (1,2,3,4,5,6)
				AND s.Functionality IN
				(
					SELECT	Functionality 
					FROM	UserTargetFunctionality 
					WHERE	UserID = @UserId --IN (SELECT Id as UserId FROM AppUser WHERE IsForMarketing = 1)
				)
				AND (
						@HasTechnology = 0 OR 
						s.Technology IN
							(
								SELECT	Technology 
								FROM	UserTargetTechnology
								WHERE	UserID = @UserId --IN (SELECT Id as UserId FROM AppUser WHERE IsForMarketing = 1)
							)
					)
				AND s.CountryId IN
				(
					SELECT	CountryId 
					FROM	UserTargetCountry
					WHERE	UserID = @UserId --IN (SELECT Id as UserId FROM AppUser WHERE IsForMarketing = 1)
				)
				AND l.SeniorityLevel IN ('C-Level','Director','Influencer')
				AND s.TechnologyCategory <> 'NA'
				AND s.IndustryId NOT IN (105,106,85)
				AND l.lastupdatedon > GETDATE() - 365
				AND s.OrganizationId NOT IN
				(
					SELECT	OrganizationId 
					FROM	WeeklyReportLastMonthIntent
					WHERE	UserId = @UserId --IN (SELECT Id as UserId FROM AppUser WHERE IsForMarketing = 1)
							AND	SentMonth = Month(GETDATE()) 
							AND SentYear = Year(GETDATE())
				)
					
		ORDER BY s.Duration DESC

	;WITH cte_report AS
		(
			SELECT	r.*,
					ROW_NUMBER() OVER (PARTITION BY CountryName,Organization ORDER BY Organization) AS [ROWNUMBER]
			FROM	#report r
		)

	DELETE FROM cte_report WHERE [ROWNUMBER] > 1
	
	Insert Into WeeklyReportLastMonthIntent
	(
				OrganizationId,
				CountryName,
				Organization,
				Technology,
				TechnologyCategory,
				DecisionMaker,
				Designation,
				Url,
				SentDate,
				SentMonth,
				SentYear,
				UserId
	)
	SELECT	Distinct TOP 3
			OrganizationId,
			CountryName,
			Organization,
			Technology,
			TechnologyCategory,
			DecisionMaker,
			Designation,
			Url,
			GETDATE() as SentDate,
			Month(GETDATE()) as SentMonth,
			Year(GETDATE()) as SentYear,
			@UserId as UserId
	FROM	#report
	ORDER BY Organization

	DROP TABLE #report

END
