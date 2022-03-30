/****** Object:  Procedure [dbo].[GetTechnologySpendsInventory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTechnologySpendsInventory]
@UserId int
AS
BEGIN
	
	SET NOCOUNT ON;
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
		SELECT	s.CountryName,
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
				AND l.lastupdatedon > GETDATE() - 180
		ORDER BY s.Duration DESC


	;WITH cte_report AS
		(
			SELECT	r.*,
					ROW_NUMBER() OVER (PARTITION BY CompanyName,Intent ORDER BY CompanyName) AS [ROWNUMBER]
			FROM	#report r
		)

	DELETE FROM cte_report WHERE [ROWNUMBER] > 1

	SELECT	DISTINCT
			CompanyName,
			Intent,
			--SpendEstimate,
			--DecisionMaker,
			--Designation,
			--Url
			Age
	FROM	#report
	--WHERE AGE < 6
	ORDER BY AGE DESC

	DROP TABLE #report
	
END

	
