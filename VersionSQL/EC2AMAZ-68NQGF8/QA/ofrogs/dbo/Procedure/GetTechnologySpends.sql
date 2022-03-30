/****** Object:  Procedure [dbo].[GetTechnologySpends]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <23rd-Oct-2020>
-- Description:	<Display last one month highest Technology Spend intent data>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologySpends] 
@TargetPersonaId int 
AS
BEGIN
	SET NOCOUNT ON;

	-- If user has configured technology display technology + functionality else functionality
	DECLARE @HasTechnology bit = (SELECT top 1 1 FROM UserTargetTechnology WHERE TargetPersonaId = @TargetPersonaId)
	SET @HasTechnology = IIF(@HasTechnology IS NULL,0,1)

	Create Table #report
	(
		Id int,
		CountryName varchar(100),
		CompanyName varchar(100),
		OrganizationId int,
		Intent varchar(150),
		SpendEstimate varchar(150),
		DecisionMaker varchar(150),
		Designation varchar(500),
		Url varchar(500),
		Age int,
		WebsiteUrl varchar(150),
		Domain varchar(100),
	)

		INSERT INTO #report
		SELECT	
				l.Id,
				s.CountryName,
				s.Organization as CompanyName,
				s.OrganizationId,
				s.Functionality as Intent,
				s.SpendEstimate,
				l.Name as DecisionMaker,
				trim(l.Designation) as Designation,
				l.URL,
				s.Duration as Age,
				  o.WebsiteUrl,
				SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
				LEN(O.WebsiteUrl)) AS [Domain]

		FROM	SurgeSummary s WITH (NOLOCK)
				Inner Join LinkedInData l WITH (NOLOCK)
				ON (l.OrganizationId = s.OrganizationId and s.CountryID = l.ResultantCountryId)
				Inner Join McDecisionMakerList m WITH (NOLOCK)
				ON (l.Id = m.DecisionMakerId and s.Functionality = m.Name)
					Inner Join Organization o
			ON (o.Id = l.OrganizationId)
			inner join TargetPersonaOrganization tpo on (tpo.OrganizationId = o.id and tpo.TargetPersonaId = @TargetPersonaId)

		WHERE	s.Duration IN (1,2,3,4,5,6)
				--AND s.Functionality IN
				--(
				--	SELECT	Functionality 
				--	FROM	UserTargetFunctionality 
				--	WHERE	UserID = @UserId
				--)
				AND (
						@HasTechnology = 0 OR s.Technology IN
							(
								SELECT	Technology 
								FROM	UserTargetTechnology
								WHERE	TargetPersonaId = @TargetPersonaId
							)
					)
				--AND s.CountryId IN
				--(
				--	SELECT	CountryId 
				--	FROM	UserTargetCountry
				--	WHERE	UserID = @UserId
				--)
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
			Id,
			CompanyName,
			OrganizationId,
			Intent,
			SpendEstimate,
			DecisionMaker,
			Designation,
			Url,
			WebsiteUrl,
			Domain
	FROM	#report
	ORDER BY CompanyName

	DROP TABLE #report
					
END
