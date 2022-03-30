/****** Object:  Procedure [dbo].[TestAdoptionFramework]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE TestAdoptionFramework
@UserId int
AS
BEGIN
	
	DECLARE @HasTechnology bit = (SELECT top 1 1 FROM UserTargetTechnology WHERE UserID = @UserId)
	SET @HasTechnology = IIF(@HasTechnology IS NULL,0,1)

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
		Age int
	)

		INSERT INTO #report
		SELECT	s.CountryName,
				s.Organization,
				s.OrganizationId,
				s.Technology,
				s.TechnologyCategory,
				l.Name as DecisionMaker,
				trim(l.Designation) as Designation,
				l.Url,
				s.Duration as Age
		FROM	SurgeSummary s WITH (NOLOCK)
				Inner Join LinkedInData l WITH (NOLOCK)
				ON (l.OrganizationId = s.OrganizationId and s.CountryID = l.ResultantCountryId)
				Inner Join McDecisionMakerList m WITH (NOLOCK)
				ON (l.Id = m.DecisionMakerId)
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
				AND m.Name IN
				(
					SELECT	Functionality 
					FROM	UserTargetFunctionality 
					WHERE	UserID = @UserId
				)
				AND l.SeniorityLevel IN ('C-Level','Director')--,'Influencer')
				AND s.TechnologyCategory <> 'NA'
				AND s.IndustryId NOT IN (105,106,85)
				AND l.lastupdatedon > GETDATE() - 180
		ORDER BY s.Duration DESC

	;WITH cte_report AS
		(
			SELECT	r.*,
					ROW_NUMBER() OVER (PARTITION BY CountryName,Organization ORDER BY Organization) AS [ROWNUMBER]
			FROM	#report r
		)

	DELETE FROM cte_report WHERE [ROWNUMBER] > 1

	SELECT	DISTINCT --TOP 50
			CountryName,
			OrganizationId,
			Organization,
			Technology,
			TechnologyCategory,
			DecisionMaker,
			Designation,
			Url
	FROM	#report
	ORDER BY Organization
END
	
