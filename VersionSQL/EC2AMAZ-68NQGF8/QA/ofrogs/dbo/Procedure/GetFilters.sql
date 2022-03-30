/****** Object:  Procedure [dbo].[GetFilters]    Committed by VersionSQL https://www.versionsql.com ******/

-- EXEC [QA_GetFilters] 159,0
-- EXEC [GetFilters] 159,1

CREATE PROCEDURE [dbo].[GetFilters] @UserId int,@AllFilter BIT
AS
BEGIN
SET NOCOUNT ON;

		DECLARE 
		@CustomerType VARCHAR(100),
		@HasConfiguration BIT,
		@HasPersona VARCHAR(100),
		@HasCustomPersona BIT,
		@PersonaIds VARCHAR(100) = 
		(SELECT PersonaIds FROM AppUser WHERE ID = @UserID)
		

		SELECT DISTINCT NAME INTO #MCteam
		FROM McDecisionmaker
		WHERE IsActive =1
		AND IsOFList =1
		AND IsTeams = 1


		SET @HasConfiguration = 
		IIF(EXISTS (SELECT * FROM UserDataContainer WHERE USERID = @USERID),1,0)

		SELECT @CustomerType = CustomerType, @HasPersona = PersonaIds,
		@HasCustomPersona = HasCustomPersona,@PersonaIds = PersonaIds
		FROM AppUser 
		WHERE ID = @UserId

		IF @HasConfiguration = 1 AND @AllFilter = 0
		BEGIN
		
		-- IntentFilter
		SELECT DISTINCT
		A.ID AdoptionID,A.Category,U.DataString Functionality
		FROM UserDataContainer U
		INNER JOIN AdoptionFramework A
		ON U.DataString = A.Functionality
		WHERE UserID = @UserID
		AND U.DataType = 'Intent'
		--AND D.DataString IS NOT NULL
		AND A.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))

		-- TeamFilter
		SELECT DISTINCT
		A.ID AdoptionID,A.Category,U.DataString Functionality
		FROM UserDataContainer U
		INNER JOIN AdoptionFramework A
		ON U.DataString = A.Functionality
		INNER JOIN #MCteam M 
		ON M.Name = A.Functionality
		WHERE UserID = @UserID
		AND U.DataType = 'Team'
		--AND U.DataType IS NOT NULL
		AND A.PersonaTypeId IN (
		SELECT VALUE FROM string_split(@PersonaIds,','))

		-- TechnologyFilter
		;WITH CTE AS(
		SELECT DISTINCT
		DataString Technology
		FROM UserDataContainer
		WHERE UserID = @UserId
		AND DataType = 'Technology')
		
		SELECT DISTINCT
		A.Id AdoptionTechnologyID,t.SubCategory TechnologyCategory,T.Technology Technology
		FROM Technologies T
		INNER JOIN AdoptionFrameworkTechnologyCategory A
		ON T.SubCategoryID = A.TechnologyCategoryId
		INNER JOIN Persona P ON P.Name = A.Category
		WHERE T.Technology IN (SELECT Technology FROM CTE)
		AND P.Id IN ( SELECT VALUE FROM string_split(@PersonaIds,','))

		Declare @SUM VARCHAR(100)
		-- EmployeeCount
		;WITH CTE AS(
		SELECT DISTINCT 
		EmployeeCount
		,COUNT(DISTINCT OrganizationID) AS Value
		FROM UserDataContainer U
		INNER JOIN Organization O ON O.ID = U.OrganizationID
		WHERE UserID = @UserId
		AND EmployeeCount IS NOT NULL
		GROUP BY EmployeeCount)
		SELECT DISTINCT
		EmployeeCount ID, EmployeeCount + ' (' + CONVERT(VARCHAR(20),Value) + ')' Name ,  
		Value nooforganizations INTO #TmpEmp
		FROM CTE

		SET @SUM = (SELECT SUM(nooforganizations)
		FROM #TmpEmp)

		SELECT * , 'All (' + @SUM + ')' AllOrganizations FROM #TmpEmp
										

		-- Revenue
		;WITH CTE AS(
		SELECT DISTINCT 
		Revenue,COUNT(DISTINCT OrganizationID) AS Value
		FROM UserDataContainer U
		INNER JOIN Organization O ON O.ID = U.OrganizationID
		WHERE UserID = @UserId
		AND Revenue IS NOT NULL
		GROUP BY Revenue)
		SELECT DISTINCT
		Revenue ID, Revenue + ' (' + CONVERT(VARCHAR(20),Value) + ')' Name ,  
		Value nooforganizations INTO #TmpRev
		FROM CTE

		
		SET @SUM = (SELECT SUM(nooforganizations)
		FROM #TmpRev)

		SELECT * , 'All (' + @SUM + ')' AllOrganizations FROM #TmpRev
		
		-- Country
		;WITH CTE AS(
		SELECT DISTINCT 
		C.id,C.name Countryname,COUNT(DISTINCT OrganizationID)  AS Value,Code
		FROM UserDataContainer U
		INNER JOIN Organization O ON O.ID = U.OrganizationID
		INNER JOIN Country C on C.ID = o.CountryId
		WHERE UserID = @UserID
		AND C.name IS NOT NULL
		GROUP BY C.name,C.id,Code)
		SELECT DISTINCT
		ID,
		Countryname, 
		Value nooforganizations,
		CountryName + ' (' + CONVERT(VARCHAR(20),Value) + ')' Name  
		INTO #TmpCou
		FROM CTE

		
		SET @SUM = (SELECT SUM(nooforganizations)
		FROM #TmpCou)

		SELECT * , 'All (' + @SUM + ')' AllOrganizations FROM #TmpCou
		
		-- IndustryName
		;WITH CTE AS(
		SELECT DISTINCT 
		I.ID,I.IndustryGroup,i.Name IndustryName,COUNT(DISTINCT OrganizationID)  AS Value
		FROM UserDataContainer U
		INNER JOIN Organization O ON O.ID = U.OrganizationID
		INNER JOIN Industry I
		ON o.IndustryId = I.Id
		WHERE UserID = @UserID
		AND i.Name IS NOT NULL
		GROUP BY i.Name,I.IndustryGroup,I.ID)
		SELECT DISTINCT
		ID,
		IndustryName, 
		IndustryGroup, 
		VALUE nooforganizations,
		IndustryName + ' (' + CONVERT(VARCHAR(20),Value) + ')' Name 
		INTO #TmpInd
		FROM CTE

		
		SET @SUM = (SELECT SUM(nooforganizations)
		FROM #TmpInd)

		SELECT * , 'All (' + @SUM + ')' AllOrganizations FROM #TmpInd


		END


		 ELSE IF @AllFilter = 1 
		 BEGIN
		 
		 PRINT '@AllFilter'
		 
		-- IntentFilter
		SELECT DISTINCT
		A.Id AdoptionID,Category,A.Functionality 
		FROM AdoptionFramework A
		
	
		
		-- TeamFilter
		SELECT DISTINCT 
		AF.Id AdoptionID,AF.Category ,AF.Functionality 
		FROM AdoptionFramework AF WITH (NOLOCK)
		INNER JOIN #MCteam ON AF.Functionality = NAME


		-- TechnologyFilter
		SELECT DISTINCT
		a.Id AdoptionTechnologyID,TechnologyCategory,T.Technology as Technology
		FROM AdoptionFrameworkTechnologyCategory A
		INNER JOIN PERSONA P ON P.Name = A.Category
		INNER JOIN Technologies T ON T.SubCategoryID = A.TechnologyCategoryId
		WHERE 
		 P.IsActive = 1
		AND T.IsActive = 1
		AND A.IsActive = 1

		
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
			 v.ID, v.IndustryName, v.IndustryGroup, v.nooforganizations, v.[Name], v.AllOrganizations
		  FROM V_TargetPersonaFilterIndustry v
			where v.IndustryName <> 'Unknown'
			order by nooforganizations desc
		 END
END
