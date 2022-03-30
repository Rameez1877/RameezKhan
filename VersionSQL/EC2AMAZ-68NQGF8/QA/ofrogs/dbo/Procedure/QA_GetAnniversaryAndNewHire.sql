/****** Object:  Procedure [dbo].[QA_GetAnniversaryAndNewHire]    Committed by VersionSQL https://www.versionsql.com ******/

-- JAN-2022 - KABIR 
-- EXEC [QA_GetAnniversaryAndNewHireFromDashboardSummary] 159,0  -- 24sec 54rec
-- EXEC [QA_GetAnniversaryAndNewHire_TEMP_TEST_MK] 159,0  -- 16 sec 54rec
CREATE PROCEDURE [dbo].[QA_GetAnniversaryAndNewHire]  
 @UserID int, @TargetPersonaId int = 0
AS
BEGIN

	DELETE FROM CompanySearchResult WHERE UserID = @UserID
	DELETE FROM ContactSearchFunctionalityResult where UserID = @UserID

	SET NOCOUNT ON;
	DECLARE @AppRoleID int, @Limit INT,@HasCustomPersona BIT,
	@PersonaID VARCHAR(200),
	@CustomTechnologyPersonaID VARCHAR(200),
	@CustomIntentPersonaID VARCHAR(200),
	@CustomTeamPersonaID  VARCHAR(200),
	@CountryFilterID VARCHAR(50),
	@CountryFilterName VARCHAR(8000),
	@DashboardCountryFilter VARCHAR(8000)

	SELECT 
	@AppRoleID = AppRoleId,
	@HasCustomPersona = HasCustomPersona,
	@PersonaID = PersonaIDs,
	@CustomIntentPersonaID = CustomIntentPersonaID,
	@CustomTeamPersonaID = CustomTeamPersonaID
	FROM AppUser 
	WHERE ID = @UserID

	IF @TargetPersonaId <> 0
	BEGIN

	print 'has targetpersonaid'

	SET @CountryFilterID = 
	IIF(EXISTS(SELECT GICs FROM TARGETPERSONA WHERE ID = @TargetPersonaId AND gics <> ''
	AND GICS IS NOT NULL
	),
	(SELECT GICs FROM TARGETPERSONA WHERE ID = @TargetPersonaId),
	(SELECT LOCATIONS FROM TARGETPERSONA WHERE ID = @TargetPersonaId))

	IF @CountryFilterID <> '' and @CountryFilterID IS NOT NULL
	BEGIN
	SELECT DISTINCT 
	@CountryFilterName = 
	string_agg(NAME,',')
	FROM Country 
	WHERE ID IN (SELECT VALUE FROM STRING_SPLIT(@CountryFilterID,','))
	END

	IF @CountryFilterID = '' OR @CountryFilterID IS NULL
	BEGIN
	SET @CountryFilterID =
	(SELECT RegionIDs
	FROM TARGETPERSONA WHERE ID = @TargetPersonaId)
	SELECT DISTINCT 
	@CountryFilterName = 
	string_agg(NAME,',')
	FROM Country 
	WHERE IsRegion IN (SELECT VALUE FROM STRING_SPLIT(@CountryFilterID,','))
	END


	IF (@HasCustomPersona = 0 OR @HasCustomPersona IS NULL) 
	BEGIN

	print 'has targetpersonaid @HasCustomPersona = 0'

	IF @PersonaId <> ''
	BEGIN

	print 'has targetpersonaid @HasCustomPersona = 0 AND @PersonaId <>'
	SELECT DISTINCT
	Functionality INTO #PersonaIDFunction
	FROM AdoptionFrameworkForDecisionmakers
	WHERE 
	IsActive = 1
	AND PersonaID IN (
	SELECT VALUE FROM STRING_SPLIT(@PersonaID,','))

	insert into ContactSearchFunctionalityResult(Functionality,UserID)
	select distinct
	Functionality,@UserID
	from #PersonaIDFunction

	;WITH CTE AS(
			SELECT 
			l.Id
			 
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND MC.NAME IN (SELECT DISTINCT Functionality FROM #PersonaIDFunction)
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))

			 UNION

			 SELECT 
			 l.Id
			 
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND MC.NAME IN (SELECT DISTINCT Functionality FROM #PersonaIDFunction)
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			UNION

		 	 SELECT 
			 l.Id
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND MC.NAME IN (SELECT DISTINCT Functionality FROM #PersonaIDFunction)
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			UNION

			SELECT 
			 l.Id
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			 convert(date,l.DateOfJoining) > getdate() - 90
			 AND T.TargetPersonaId = @TargetPersonaId
			 AND MC.NAME IN (SELECT DISTINCT Functionality FROM #PersonaIDFunction)
			 AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			 )
			 INSERT INTO CompanySearchResult(ID,UserID)
			 SELECT  DISTINCT 
			 Id,@UserID
			 FROM CTE
			 
			END


			ELSE IF @PersonaID IS NULL OR @PersonaID = ''
			BEGIN 

	insert into ContactSearchFunctionalityResult(Functionality,UserID)
			values ('1',@UserID)

			;WITH CTE AS(
			SELECT 
			 l.Id
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))

			 UNION

			 SELECT 
			 l.Id
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))

			UNION

		 	 SELECT 
			 l.Id
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			UNION

			SELECT
			 l.Id
			 
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			 convert(date,l.DateOfJoining) > getdate() - 90
			 AND T.TargetPersonaId = @TargetPersonaId
			 AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			 )
			 INSERT INTO CompanySearchResult(ID,UserID)
			 SELECT  DISTINCT 
			 Id,@UserID
			 FROM CTE
			 
			END
			 
			 
			END 
			ELSE IF @HasCustomPersona = 1  
			BEGIN

			PRINT 'HAS TARGETPERSONA @HasCustomPersona = 1'

	SELECT DISTINCT
	Functionality INTO #CustomPersonaFunction
	FROM ADOPTIONFRAMEWORK
	WHERE 
	IsActive = 1
	AND Id IN (
	SELECT VALUE FROM STRING_SPLIT(@CustomIntentPersonaID,','))

	INSERT INTO #CustomPersonaFunction (Functionality)
	SELECT DISTINCT
	Functionality 
	FROM AdoptionFramework
	WHERE 
	IsActive =1 AND
	Id IN (
	SELECT VALUE FROM STRING_SPLIT(@CustomTeamPersonaID,','))

	insert into ContactSearchFunctionalityResult(Functionality,UserID)
	select distinct Functionality,@UserID from #CustomPersonaFunction

	;WITH CTE AS(
			SELECT 
			l.Id
			
	FROM	NewHireTouchPoint l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CustomIntentPersonaID is null or @CustomTeamPersonaID is null or 
			MC.NAME IN (SELECT DISTINCT Functionality FROM #CustomPersonaFunction)) 
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			 UNION

			 SELECT l.Id
			
	FROM	NewHireTouchPoint l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CustomIntentPersonaID is null or @CustomTeamPersonaID is null or 
			MC.NAME IN (SELECT DISTINCT Functionality FROM #CustomPersonaFunction)) 
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			UNION

		 	 SELECT l.Id
			 
	FROM	NewHireTouchPoint l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND T.TargetPersonaId = @TargetPersonaId
			AND (@CustomIntentPersonaID is null or @CustomTeamPersonaID is null or MC.NAME IN (SELECT DISTINCT Functionality FROM #CustomPersonaFunction)) 
			 AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			UNION

			SELECT l.Id
				FROM	NewHireTouchPoint l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join TargetPersonaOrganization T  With (Nolock) on (T.OrganizationId = L.OrganizationId) 
			INNER JOIN Organization O With (Nolock) ON O.ID = T.ORGANIZATIONID
	WHERE	
			 convert(date,l.DateOfJoining) > getdate() - 90
			 AND T.TargetPersonaId = @TargetPersonaId
			AND (@CustomIntentPersonaID is null or @CustomTeamPersonaID is null or MC.NAME IN (SELECT DISTINCT Functionality FROM #CustomPersonaFunction)) 
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@CountryFilterName,',')))
			)
			INSERT INTO CompanySearchResult(ID,UserID)
			 SELECT DISTINCT 
			 Id,@UserID
			 FROM CTE
			 
		END 
		END 
		ELSE
		BEGIN



	IF (@HasCustomPersona = 0 OR @HasCustomPersona IS NULL) AND @PersonaID <> ''
	BEGIN
		

	print 'without targetpersonaid @HasCustomPersona = 0'

	;WITH CTE AS (
	SELECT DISTINCT
	c.name CountryName
	FROM UserDataContainer U
	INNER JOIN Organization o on o.id = u.organizationid
	INNER JOIN Country c on c.id = o.countryid
	where u.UserID = @UserID
	)

	SELECT 
	@DashboardCountryFilter = string_agg(CountryName,',') 
	FROM CTE

	insert into ContactSearchFunctionalityResult(Functionality,UserID)
	select distinct Functionality,@UserID
	from AdoptionFrameworkForDecisionmakers
	where PersonaID in (select value from string_split(@PersonaID,','))
	and IsActive = 1

			;WITH CTE AS(
			SELECT  l.Id
			 
	FROM	NewHireTouchPoint l  With (Nolock)
			Inner Join McDecisionMakerListNewHire MC   With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join UserDataContainer DS With (Nolock) on DS.OrganizationId = L.OrganizationId			
			INNER JOIN Organization O With (Nolock) ON O.ID = ds.OrganizationID
			INNER JOIN AdoptionFrameworkForDecisionmakers A ON A.FUNCTIONALITY = MC.NAME
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND DS.UserID = @UserID
			AND A.PersonaID IN (SELECT VALUE FROM string_split(@PersonaID,','))
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@DashboardCountryFilter,',')))
			and a.IsActive = 1
			 UNION

			 SELECT l.Id
			
	FROM	NewHireTouchPoint l  With (Nolock)
			Inner Join McDecisionMakerListNewHire MC   With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join UserDataContainer DS With (Nolock) on DS.OrganizationId = L.OrganizationId			
			INNER JOIN Organization O With (Nolock) ON O.ID = ds.OrganizationID
			INNER JOIN AdoptionFrameworkForDecisionmakers A ON A.FUNCTIONALITY = MC.NAME
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND DS.UserID = @UserID
			AND A.PersonaID IN (SELECT VALUE FROM string_split(@PersonaID,','))
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@DashboardCountryFilter,',')))
			AND A.IsActive = 1
			UNION

		 	 SELECT  l.Id
			 
	FROM	NewHireTouchPoint l  With (Nolock)
			Inner Join McDecisionMakerListNewHire MC   With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join UserDataContainer DS With (Nolock) on DS.OrganizationId = L.OrganizationId			
			INNER JOIN Organization O With (Nolock) ON O.ID = ds.OrganizationID
			INNER JOIN AdoptionFrameworkForDecisionmakers A ON A.FUNCTIONALITY = MC.NAME
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND DS.UserID = @UserID
			AND A.PersonaID IN (SELECT VALUE FROM string_split(@PersonaID,','))
			AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@DashboardCountryFilter,',')))
			AND A.IsActive = 1
			UNION

			SELECT l.Id
			
	FROM	NewHireTouchPoint l  With (Nolock)
			Inner Join McDecisionMakerListNewHire MC   With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join UserDataContainer DS With (Nolock) on DS.OrganizationId = L.OrganizationId			
			INNER JOIN Organization O With (Nolock) ON O.ID = ds.OrganizationID
			INNER JOIN AdoptionFrameworkForDecisionmakers A ON A.FUNCTIONALITY = MC.NAME
	WHERE	
			 convert(date,l.DateOfJoining) > getdate() - 90
			 AND DS.USERID = @UserID
			AND A.PersonaID IN (SELECT VALUE FROM string_split(@PersonaID,','))
			 AND (@CountryFilterName = '' OR ResultantCountry IN (
			SELECT VALUE FROM string_split(@DashboardCountryFilter,',')))
			AND A.IsActive = 1
			 )
			 INSERT INTO CompanySearchResult(ID,UserID)
			 SELECT  DISTINCT
			 Id,@UserID
			 FROM CTE
			END
End
END
