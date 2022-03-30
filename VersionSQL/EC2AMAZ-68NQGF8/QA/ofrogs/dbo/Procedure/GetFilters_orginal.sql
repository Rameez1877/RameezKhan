/****** Object:  Procedure [dbo].[GetFilters_orginal]    Committed by VersionSQL https://www.versionsql.com ******/

-- EXEC [GetFilters] 159,0
Create PROCEDURE [dbo].[GetFilters_orginal] @UserId int,@AllFilter BIT

AS
BEGIN
	SET NOCOUNT ON;
		
		DECLARE 
		@CustomerType VARCHAR(100),
		@IsTeam BIT,
		@PersonaIds VARCHAR(100) = 
		(SELECT PersonaIds FROM AppUser WHERE ID = @UserID)
		
			SELECT DISTINCT NAME INTO #MCteam
		FROM McDecisionmaker
		WHERE IsActive =1
		AND IsOFList =1


		SET @IsTeam = 
		IIF(EXISTS (SELECT * FROM DASHBOARDTEAMDATA WHERE USERID = @USERID),1,0)

		SELECT @CustomerType = CustomerType
		FROM AppUser 
		WHERE ID = @UserId

		IF @CustomerType <> '' AND @CustomerType IS NOT NULL AND @AllFilter = 0
		BEGIN


		IF  @IsTeam = 0
		BEGIN
		
		-- IntentFilter
		SELECT DISTINCT
		'IntentFilter' AdvancedFilterType, Category,A.Functionality --INTO #TmpIntent
		FROM AdoptionFramework A
		INNER JOIN DashboardDataSummary D ON A.Functionality = D.Functionality
		WHERE 
		PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))
		AND D.UserID = @UserID
	
		
		--TeamFilter

	

		SELECT DISTINCT 
		'TeamFilter' AS AdvancedFilterType,AF.Category ,AF.Functionality 
		FROM DashboardDataSummary D WITH (NOLOCK)
		INNER JOIN AdoptionFramework AF WITH (NOLOCK)
		ON D.Functionality = AF.Functionality
		INNER JOIN #MCteam ON AF.Functionality = NAME
		WHERE D.UserID = @UserID AND AF.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))

		--;WITH CTE AS(
		--SELECT Category,Functionality
		--FROM AdoptionFramework 
		--WHERE 
		--PersonaTypeId IN (
		--SELECT VALUE FROM string_split(@PersonaIds,',')))
		--SELECT DISTINCT 
		--'TeamFilter' AS FilterType , Category,Functionality --INTO #TmpTeam
		--FROM CTE 
		--WHERE Functionality IN (
		--SELECT DISTINCT NAME 
		--FROM McDecisionmaker
		--WHERE IsActive =1
		--AND IsOFList =1
		--AND IsTeams = 1)

		

		-- TechnologyFilter
		SELECT DISTINCT
		'TechnologyFilter' AdvancedFilterType,TechnologyCategory,D.Technology
		
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		INNER JOIN DashboardDataSummary D ON D.Technology = TST.STACKTECHNOLOGYNAME
		WHERE 
		p.id IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))
		AND P.ISACTIVE = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND D.UserID = @UserID

		
		SELECT DISTINCT 'EmployeeCountFilter' AS FilterType, EmployeeCount
		FROM DashboardDataSummary
		WHERE UserID = @UserID --and EmployeeCount <> 'Unknown'
		
		SELECT DISTINCT 'RevenueFilter' AS FilterType, Revenue
		FROM DashboardDataSummary
		WHERE UserID = @UserID --and Revenue <> 'Unknown'
		
		SELECT DISTINCT 'CountryNameFilter' AS FilterType, CountryName
		FROM DashboardDataSummary
		WHERE UserID = @UserID and CountryName <> 'Unknown'
		
		SELECT DISTINCT i.Id, IndustryName
		FROM DashboardDataSummary D
		inner join industry i on i.Name = d.IndustryName
		WHERE UserID = @UserID and IndustryName <> 'Unknown'

		END





		PRINT 'HasConfiguration'
		IF @IsTeam = 1
		BEGIN
		PRINT 'Has Team'

		-- TeamFilter
		SELECT DISTINCT 'TeamFilter' as FilterType,
		AF.Category ,AF.Functionality --INTO #TempFunc
		FROM DashboardTeamData D
		INNER JOIN AdoptionFramework AF
		ON D.Functionality = AF.Functionality
		WHERE D.UserID = @UserID  AND AF.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))

		END
		END

		 ELSE IF @AllFilter = 1
		 BEGIN

		 -- IntentFilter
		SELECT DISTINCT
		'IntentFilter' AdvancedFilterType, Category,A.Functionality 
		FROM AdoptionFramework A
		
	
		
		--TeamFilter
		

		SELECT DISTINCT 
		'TeamFilter' AS AdvancedFilterType,AF.Category ,AF.Functionality 
		FROM AdoptionFramework AF WITH (NOLOCK)
		INNER JOIN #MCteam ON AF.Functionality = NAME


		-- TechnologyFilter
		SELECT DISTINCT
		'TechnologyFilter' AdvancedFilterType,TechnologyCategory,TST.StackTechnologyName
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = A.TechnologyCategoryId
		INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
		WHERE 
		 P.IsActive = 1
		AND TST.IsActive = 1
		AND A.IsActive = 1
		AND TST.IsActive =1

		
		SELECT DISTINCT 'EmployeeCountFilter' AS FilterType, EmployeeCount
		FROM Organization --WHERE EmployeeCount <> 'Unknown'
	

		SELECT DISTINCT 'RevenueFilter' AS FilterType, Revenue
		FROM Organization --WHERE Revenue <> 'Unknown'
		

		SELECT DISTINCT 'CountryNameFilter' AS FilterType,C.NAME CountryName
		FROM Organization
		INNER JOIN COUNTRY C ON C.ID = COUNTRYID 
		WHERE C.ISACTIVE =1 and c.name <> 'Unknown'

		SELECT DISTINCT I.Id, I.[Name] IndustryName
		FROM Organization
		INNER JOIN INDUSTRY I ON I.ID = INDUSTRYID
		WHERE I.ISACTIVE = 1 and I.NAME <>  'Unknown'

		 END
END
