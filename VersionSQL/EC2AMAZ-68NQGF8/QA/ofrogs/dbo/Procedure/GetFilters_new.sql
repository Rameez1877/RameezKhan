/****** Object:  Procedure [dbo].[GetFilters_new]    Committed by VersionSQL https://www.versionsql.com ******/

-- EXEC [GetFilters] 159,0
--- EXEC [GetFilters_new] 159,0
CREATE PROCEDURE [dbo].[GetFilters_new] @UserId int,@AllFilter BIT

AS
BEGIN
	SET NOCOUNT ON;
		
		DECLARE 
		@CustomerType VARCHAR(100),
		@IsTeam BIT,
		@HasPersona VARCHAR(100),
		@HasCustomPersona BIT,
		@PersonaIds VARCHAR(100) = 
		(SELECT PersonaIds FROM AppUser WHERE ID = @UserID)
		

			SELECT DISTINCT NAME INTO #MCteam
		FROM McDecisionmaker
		WHERE IsActive =1
		AND IsOFList =1
		AND IsTeams = 1

		--SET @AllFilter = 
		--IIF(EXISTS (SELECT * FROM AppUser WHERE Id = @USERID and CustomerType is null),1,@AllFilter)

		SET @IsTeam = 
		IIF(EXISTS (SELECT * FROM DASHBOARDTEAMDATA WHERE USERID = @USERID),1,0)

		SELECT @CustomerType = CustomerType, @HasPersona = PersonaIds,
		@HasCustomPersona = HasCustomPersona
		FROM AppUser 
		WHERE ID = @UserId

		IF @CustomerType <> '' AND @CustomerType IS NOT NULL AND @AllFilter = 0
		BEGIN

		print 'configured'
		IF  @IsTeam = 0 AND @HasPersona <> '' AND @HasPersona IS NOT NULL
		BEGIN
		print 'istream = 0'
		-- IntentFilter

		-- CUSTOMPERSONA = 1
		-- = 0
		SELECT DISTINCT
		 Category,A.Functionality --INTO #TmpIntent
		FROM AdoptionFramework A
		INNER JOIN DashboardDataSummary D ON (A.Functionality = D.Functionality and D.UserID = @UserID)
		WHERE  
		 @PersonaIds = '' or (
		PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))
		
	
		
		--TeamFilter
		SELECT DISTINCT 
		AF.Category ,AF.Functionality 
		FROM DashboardDataSummary D WITH (NOLOCK)
		INNER JOIN AdoptionFramework AF WITH (NOLOCK)
		ON D.Functionality = AF.Functionality
		INNER JOIN #MCteam ON (AF.Functionality = NAME AND  D.UserID = @UserID)
		WHERE
		 @PersonaIds = '' or (
		AF.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))


		-- TechnologyFilter  
		-- problem here for hascustompersona
		SELECT DISTINCT
		TechnologyCategory,D.Technology
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		INNER JOIN DashboardDataSummary D ON (D.Technology = TST.STACKTECHNOLOGYNAME AND D.UserID = @UserID)
		WHERE 
		 P.ISACTIVE = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND
		@PersonaIds = '' or (
		p.id IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))
		
		--SELECT DISTINCT D.EmployeeCount as Id, D.EmployeeCount as [Name]
		--FROM DashboardDataSummary d
		--WHERE UserID = @UserId --and EmployeeCount <> 'Unknown'
		
		
		--SELECT DISTINCT D.Revenue as [Id], D.Revenue as [Name]
		--FROM DashboardDataSummary d
		--WHERE UserID = @UserID --and Revenue <> 'Unknown'
		
		--SELECT distinct
		--	C.Id, D.CountryName as [Name] 
	 -- FROM DashboardDataSummary D
		--inner join Country c on d.CountryName = c.[Name]
		--WHERE D.UserID =  @UserID 

		--   SELECT distinct
		--	 I.Id, I.Name, I.IndustryGroup
		--  FROM DashboardDataSummary d
		--  inner join Industry I on D.IndustryName = I.[Name]
		--  WHERE UserID =  @UserID 
		--  and D.IndustryName <> 'Unknown'
		  

		END

		ELSE IF @IsTeam = 0 AND @HasPersona = '' AND @HasCustomPersona = 1 --OR @HasPersona IS NULL
		
		
		
		BEGIN
		-- NEW CONDITIONS
		PRINT 'ELSE IF 129' 
		DECLARE 
		@CustomIntentPersonaID  VARCHAR(100),
		@CustomTechnologyPersonaID VARCHAR(100),
		@CustomTeamPersonaID VARCHAR(100)

		SELECT @CustomIntentPersonaID = CustomIntentPersonaID,
		@CustomTechnologyPersonaID = CustomTechnologyPersonaID,
		@CustomTeamPersonaID = CustomTeamPersonaID
		FROM AppUser 
		WHERE ID = @UserId

		SELECT DISTINCT
		 Category,A.Functionality --INTO #TmpIntent
		FROM AdoptionFramework A
		INNER JOIN DashboardDataSummary D ON A.Functionality = D.Functionality
		WHERE  D.UserID = @UserID
		AND 
		A.Id IN (
		SELECT VALUE FROM string_split(@CustomIntentPersonaID,','))
		
	
		
		--TeamFilter
		SELECT DISTINCT 
		AF.Category ,AF.Functionality 
		FROM DashboardDataSummary D WITH (NOLOCK)
		INNER JOIN AdoptionFramework AF WITH (NOLOCK)
		ON D.Functionality = AF.Functionality
		INNER JOIN #MCteam ON AF.Functionality = NAME
		WHERE D.UserID = @UserID
		AND 
		AF.Id IN (
		SELECT VALUE FROM string_split(@CustomTeamPersonaID,','))

		-- TECHNOLOGY
		SELECT DISTINCT
		TechnologyCategory,D.Technology
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		INNER JOIN DashboardDataSummary D ON D.Technology = TST.STACKTECHNOLOGYNAME
		WHERE 
		 P.ISACTIVE = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND D.UserID = @UserID
		AND
		
		A.Id IN (
		SELECT VALUE FROM string_split(@CustomTechnologyPersonaID,','))
		
		SELECT DISTINCT D.EmployeeCount as Id, D.EmployeeCount as [Name]
		FROM DashboardDataSummary d
		WHERE UserID = @UserId --and EmployeeCount <> 'Unknown'
		
		
		SELECT DISTINCT D.Revenue as [Id], D.Revenue as [Name]
		FROM DashboardDataSummary d
		WHERE UserID = @UserID --and Revenue <> 'Unknown'
		
		SELECT distinct
			C.Id, D.CountryName as [Name] 
	  FROM DashboardDataSummary D
		inner join Country c on d.CountryName = c.[Name]
		WHERE D.UserID =  @UserID 

		   SELECT distinct
			 I.Id, I.Name, I.IndustryGroup
		  FROM DashboardDataSummary d
		  inner join Industry I on D.IndustryName = I.[Name]
		  WHERE UserID =  @UserID 
		  and D.IndustryName <> 'Unknown'

		
		-------- NEW CONDITIONS
		END

		--PRINT 'HasConfiguration'
		IF @IsTeam = 1
		BEGIN
		PRINT 'Has Team'

		-- IntentFilter
		SELECT DISTINCT
		 Category,A.Functionality --INTO #TmpIntent
		FROM AdoptionFramework A
		INNER JOIN DashboardTeamData D ON A.Functionality = D.Functionality
		WHERE  D.UserID = @UserID
		and @PersonaIds = '' or (
		PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))
		



		-- TeamFilter
		SELECT DISTINCT
		AF.Category ,AF.Functionality --INTO #TempFunc
		FROM DashboardTeamData D
		INNER JOIN AdoptionFramework AF
		ON D.Team = AF.Functionality  -- changed d.functionality to d.team 
		WHERE D.UserID = @UserID  AND @PersonaIds = '' or (
		AF.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))


		SELECT DISTINCT
		TechnologyCategory,D.Technology
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		INNER JOIN DashboardTeamData D ON D.Technology = TST.STACKTECHNOLOGYNAME
		WHERE 
		 P.ISACTIVE = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND D.UserID = @UserID
		AND
		@PersonaIds = '' or (
		p.id IN (
		SELECT VALUE FROM string_split(@PersonaIds,',')))

		SELECT DISTINCT D.EmployeeCount as Id, D.EmployeeCount as [Name]
		FROM DashboardDataSummary d
		WHERE UserID = @UserId --and EmployeeCount <> 'Unknown'
		
		
		SELECT DISTINCT D.Revenue as [Id], D.Revenue as [Name]
		FROM DashboardDataSummary d
		WHERE UserID = @UserID --and Revenue <> 'Unknown'
		
		SELECT distinct
			C.Id, D.CountryName as [Name] 
	  FROM DashboardDataSummary D
		inner join Country c on d.CountryName = c.[Name]
		WHERE D.UserID =  @UserID 

		   SELECT distinct
			 I.Id, I.Name, I.IndustryGroup
		  FROM DashboardDataSummary d
		  inner join Industry I on D.IndustryName = I.[Name]
		  WHERE UserID =  @UserID 
		  and D.IndustryName <> 'Unknown'


		END
		END

		 ELSE IF @AllFilter = 1
		 BEGIN
		 PRINT '@AllFilter = 1'
		 -- IntentFilter
		SELECT DISTINCT
		 Category,A.Functionality 
		FROM AdoptionFramework A
		
	
		
		--TeamFilter
		

		SELECT DISTINCT 
		AF.Category ,AF.Functionality 
		FROM AdoptionFramework AF WITH (NOLOCK)
		INNER JOIN #MCteam ON AF.Functionality = NAME


		-- TechnologyFilter
		SELECT DISTINCT
		TechnologyCategory,TST.StackTechnologyName as Technology
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		WHERE 
		 P.IsActive = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND TST.IsActive =1

		
		SELECT DISTINCT Id, [Name], nooforganizations, AllOrganizations
		FROM  V_TargetPersonaFilterEmpCount  --WHERE EmployeeCount <> 'Unknown'
		order by [Name]

		SELECT DISTINCT v.ID, v.[Name], V.nooforganizations, V.AllOrganizations
		from V_TargetPersonaFilterRevenue v
		order by [Name]  --and Revenue <> 'Unknown'
		
	 SELECT
			Id,
			countryname,
			nooforganizations,
			Name,
			AllOrganizations,
			code
	  FROM V_TargetPersonaFilterCountry
	  	  ORDER BY nooforganizations DESC

		   SELECT distinct
			 v.Id, v.IndustryName, v.IndustryGroup, v.nooforganizations, v.[Name], v.AllOrganizations
		  FROM V_TargetPersonaFilterIndustry v
			where v.IndustryName <> 'Unknown'
			order by nooforganizations desc
		 END
END
