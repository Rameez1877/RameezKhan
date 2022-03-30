/****** Object:  Procedure [dbo].[PopulateGetTechnologySpends]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <04th-Nov-2020>
-- Description:	<Populate last one month highest Technology Spend intent data>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateGetTechnologySpends] 
@UserId int,
@Count int
AS
BEGIN
	SET NOCOUNT ON;

	-- If user has configured technology display technology + functionality else functionality
	DECLARE @HasTechnology bit = (SELECT top 1 1 FROM UserTargetTechnology WHERE UserID = @UserId)
	SET @HasTechnology = IIF(@HasTechnology IS NULL,0,1)

	Create Table #report
	(
		CountryName varchar(100),
		CompanyName varchar(100),
		OrganizationId int,
		Intent varchar(150),
		SpendEstimate varchar(150),
		DecisionMaker varchar(150),
		Designation varchar(500),
		Url varchar(500),
		Age int
	)

		INSERT INTO #report
		SELECT	TOP (@Count)
				s.CountryName,
				s.Organization as CompanyName,
				s.OrganizationId,
				s.Functionality as Intent,
				s.SpendEstimate,
				l.Name as DecisionMaker,
				trim(l.Designation) as Designation,
				l.URL,
				s.Duration as Age

		FROM	SurgeSummary s WITH (NOLOCK)
				Inner Join LinkedInData l WITH (NOLOCK)
				ON (l.OrganizationId = s.OrganizationId and s.CountryId = l.ResultantCountryId)
				Inner Join McDecisionMakerList m WITH (NOLOCK)
				ON (l.Id = m.DecisionMakerId and s.Functionality = m.Name)
		WHERE	s.Duration IN (1,2,3,4,5,6)
				AND s.Functionality IN
				(
					SELECT	Functionality 
					FROM	UserTargetFunctionality 
					WHERE	UserID = @UserId
				)
				AND (
						@HasTechnology = 0 OR s.Technology IN
							(
								SELECT	Technology 
								FROM	UserTargetTechnology
								WHERE	UserID = @UserId
							)
					)
				AND s.CountryId IN
				(
					SELECT	CountryId 
					FROM	UserTargetCountry
					WHERE	UserID = @UserId
				)
				AND l.SeniorityLevel IN ('C-Level','Director','Influencer')
				AND s.SpendEstimate IN ('Extreme High','Very High','High')
				AND s.IndustryId NOT IN (105,106,85)
				AND l.lastupdatedon > GETDATE() - 365
				AND s.OrganizationId NOT IN
				(
					SELECT	OrganizationId 
					FROM	WeeklyReportTechnologySpends
					WHERE	UserId = @UserId 
							AND	SentMonth = Month(GETDATE()) 
							AND SentYear = Year(GETDATE())
				)
		ORDER BY s.Duration DESC


	;WITH cte_report AS
		(
			SELECT	r.*,
					ROW_NUMBER() OVER (PARTITION BY CompanyName,Intent ORDER BY CompanyName) AS [ROWNUMBER]
			FROM	#report r
		)

	DELETE FROM cte_report WHERE [ROWNUMBER] > 1

	Insert Into WeeklyReportTechnologySpends
	(
				OrganizationId,
				CountryName,
				CompanyName,
				Intent,
				SpendEstimate,
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
			CompanyName,
			Intent,
			SpendEstimate,
			DecisionMaker,
			Designation,
			Url,
			GETDATE() as SentDate,
			Month(GETDATE()) as SentMonth,
			Year(GETDATE()) as SentYear,
			@UserId as UserId
	FROM	#report
	ORDER BY CompanyName

	DROP TABLE #report

END
