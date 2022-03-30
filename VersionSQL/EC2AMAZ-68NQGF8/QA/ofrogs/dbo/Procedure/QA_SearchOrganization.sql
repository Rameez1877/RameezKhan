/****** Object:  Procedure [dbo].[QA_SearchOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- Script Date: 05-Jan-22 - Kabir
-- last edit: 24-Feb-2022
CREATE PROCEDURE [dbo].[QA_SearchOrganization] 
	@UserId int,
    @IndustryIds varchar(max) = '',
    @CountryIds varchar(max) = '',
    @EmployeeCounts varchar(max) = '',
    @Revenues varchar(8000) = '',
    @TechnologyNames varchar(8000) = '',
    @TeamNames varchar(8000) = '',
	@Functionalities varchar(8000) = '',
	@GicCountryIds varchar(8000) = '',
	@IsSearchAll BIT = 0
AS BEGIN
SET NOCOUNT ON;
	


DECLARE @PersonaIds VARCHAR(200), @RegionIds VARCHAR(200),  @IndustryGroupIds VARCHAR(200)


SELECT @PersonaIds = PersonaIds,@RegionIds = RegionIds,@IndustryGroupIds = IndustryGroupIds FROM AppUser WHERE Id = @UserID

SELECT VALUE INTO #PersonaIds FROM string_split(@PersonaIds,',')
SELECT VALUE INTO #RegionIds FROM string_split(@RegionIds,',')
SELECT VALUE INTO #IndustryGroupIds FROM string_split(@IndustryGroupIds,',')

SELECT VALUE INTO #CountryIds FROM string_split(@CountryIds,',')
SELECT VALUE INTO #IndustryIds FROM string_split(@IndustryIds,',')
SELECT VALUE INTO #TechnologyNames FROM string_split(@TechnologyNames,',')
SELECT VALUE INTO #TeamNames FROM string_split(@TeamNames,',')
SELECT VALUE INTO #Functionalities FROM string_split(@Functionalities,',')




	DELETE FROM CompanySearchResult WHERE USERID = @UserId
	DECLARE @Condition INT =0

	SET @Condition = IIF(@IsSearchAll = 1,1,@Condition)

	SET @Condition = IIF( @TechnologyNames <> '' OR @TeamNames <> '' OR @Functionalities <> '' AND @IsSearchAll = 1 ,2,@Condition)

	SET @Condition = IIF( (@TechnologyNames = '' AND @TeamNames = '' AND @Functionalities = '') AND (@CountryIds <> '' OR @IndustryIds <> '' OR @EmployeeCounts <> '' OR @Revenues <> '')  AND @IsSearchAll = 1 ,3,@Condition)

	SET @Condition = IIF(  @TeamNames <> '' AND @TechnologyNames = '' AND @Functionalities = '' AND @IsSearchAll = 0,4,@Condition)

	SET @Condition = IIF( @TechnologyNames <> '' AND @TeamNames = '' AND @Functionalities = '' AND @IsSearchAll = 0,5,@Condition)

	SET @Condition = IIF( @Functionalities <> '' AND @TeamNames = '' AND @TechnologyNames = '' AND @IsSearchAll = 0,6,@Condition)

	SET @Condition = IIF(((@TeamNames <> '' AND @TechnologyNames <> '' AND @Functionalities = '') 
		OR (@TeamNames <> '' AND @TechnologyNames = '' AND @Functionalities <> '') 
		OR (@TeamNames = '' AND @TechnologyNames <> '' AND @Functionalities <> '') ) AND @IsSearchAll = 0 ,7,@Condition)

	SET @Condition = IIF((@TechnologyNames= '' AND @TeamNames = '' AND @Functionalities = '' AND @IsSearchAll = 0) AND (@Revenues <> '' OR @EmployeeCounts <> '' OR @IndustryIds <> ''
			OR @CountryIds <> '' ) AND @IsSearchAll = 0 ,8,@Condition)

	SET @Condition = IIF((@TechnologyNames <> '' AND @TeamNames <> '' AND @Functionalities <> '') AND @IsSearchAll = 0,9,@Condition)


			PRINT @Condition



	
	CREATE TABLE #Datas(DataValue INT)

	 IF
	@Condition = 2
	BEGIN
	PRINT @Condition
	
	CREATE TABLE #DatasTech (OrganizationId INT)
	CREATE TABLE #DatasTeam (OrganizationId INT)
	CREATE TABLE #DatasIntent (OrganizationId INT)


	INSERT INTO #DatasTech
	SELECT Distinct
	OrganizationId
	FROM Master.OrganizationSummary OS
	INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = OS.TechnologyFunctionalityID
	INNER JOIN Organization O 
	ON O.ID = os.OrganizationID
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	WHERE 
	(os.TechnologyFunctionalityID in (SELECT VALUE FROM string_split(@TechnologyNames,',')))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
	AND MP.IsActive =1 AND MP.PersonaID <> 59


	INSERT INTO #DatasTeam
	SELECT Distinct
	OrganizationId
	FROM master.OrganizationSummary OS
	INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = OS.TechnologyFunctionalityID
	INNER JOIN Organization O 
	ON O.ID = OS.OrganizationID
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	INNER JOIN #Datas D ON D.DataValue = OS.OrganizationID
	WHERE 
	OS.TechnologyFunctionalityID in (SELECT VALUE FROM string_split(@TeamNames,','))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
	AND MP.IsActive =1 AND MP.PersonaID <> 59

	INSERT INTO #DatasIntent
	SELECT Distinct
	OrganizationId
	FROM  MASTER.OrganizationSummary OS WITH (NOLOCK)
	INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = OS.TechnologyFunctionalityID
	INNER JOIN Organization O  WITH (NOLOCK)
	ON O.ID = OS.OrganizationId
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	INNER JOIN #Datas D ON D.DataValue = OS.OrganizationID
	WHERE 
	OS.TechnologyFunctionalityID in (SELECT VALUE FROM string_split(@Functionalities,','))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
	AND MP.IsActive =1 AND MP.PersonaID <> 59



	INSERT INTO CompanySearchResult (Id,UserID)
	SELECT DISTINCT O.Id,@UserId
	from  #DatasIntent DI
	FULL OUTER JOIN #DatasTeam DT ON DT.OrganizationId = DI.OrganizationId
	FULL OUTER JOIN #DatasTech DTE ON DTE.OrganizationId = DT.OrganizationId
	INNER JOIN Organization O ON (O.Id = DI.OrganizationId OR O.ID = DT.OrganizationId OR O.Id = DTE.OrganizationId) 
	
	
	EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''
	END

	ELSE IF @Condition = 3
	BEGIN
	
	PRINT @Condition
	INSERT INTO CompanySearchResult (Id,UserID)
	SELECT DISTINCT  
	O.Id,@UserId
	FROM Organization O  WITH (NOLOCK)
	INNER JOIN Country C ON C.ID = O.CountryId
	INNER JOIN Industry I ON I.Id = O.IndustryId

	WHERE 
	C.IsRegion IN (1,4,7,11)
	AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
		EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''
		END
	


IF @Condition = 4
BEGIN
PRINT @Condition
	insert into CompanySearchResult (ID,UserID)
			SELECT distinct
				O.ID,@UserId 
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #TeamNames T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			inner join #RegionIds R ON r.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
	 WHERE
             (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )

			EXEC QA_GetCompanySearchResult @UserID,0,10,'','','','',''
			END
			 
			ELSE IF @Condition = 5
			BEGIN
			PRINT @Condition

			insert into CompanySearchResult (ID,UserID)
			SELECT distinct
				O.ID,@UserId 
			FROM 
			master.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #TechnologyNames T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			inner join #RegionIds R ON r.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID

	 WHERE
	
             (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
			EXEC QA_GetCompanySearchResult @UserID,0,10,'','','','',''
			END


			ELSE IF @Condition = 6 
			BEGIN
			PRINT @Condition
			insert into CompanySearchResult (ID,UserID)
			SELECT distinct
				O.ID,@UserId 
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #Functionalities T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			inner join #RegionIds R ON r.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
	 WHERE
            (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
			EXEC QA_GetCompanySearchResult @UserID,0,10,'','','','',''
		END

		ELSE IF @Condition = 7
		
		BEGIN
		PRINT @Condition
		
		create table #team (id int)
		create table #Technology (id int)
		create table #Intent (id int)
		if @TeamNames <> ''

		insert into #team
		SELECT distinct
				O.ID
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #TeamNames T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			INNER JOIN #RegionIds R ON R.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
	 WHERE
           (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
			

			if @TechnologyNames <> ''
			insert into #Technology
			SELECT distinct
				O.ID 
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #TechnologyNames T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			INNER JOIN #RegionIds R ON R.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
			
	 WHERE
            (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
			

			if @Functionalities <> ''
			insert into #Intent
			SELECT distinct
				O.ID 
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #Functionalities T ON T.value = MP.TechTeamIntentID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			INNER JOIN #RegionIds R ON R.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
	 WHERE
             (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )


		;with cte as (
		select id from #Team
		union
		select id from #Technology
		
		)
		select id into #TeamTech from cte 

		;with cte as (
		select Id from #Intent
		union
		select id from #Technology
		)
		select id into #IntetnTech from cte 

		;with cte as (
		select id from #Team
		union
		select id from #Intent
		)
		select id into #TeamIntent from cte 

	;WITH CTE AS (
			SELECT Y.Id 
			 FROM
			#Intent I
			INNER join #TeamTech y on i.Id = y.Id
			UNION
			
			SELECT TE.Id
			FROM #Team T 
			INNER join #IntetnTech te on te.Id = t.Id
			UNION
			
			SELECT T.ID
			FROM #Technology TE
			INNER join #TeamIntent t on te.Id = t.Id
			)
			insert into CompanySearchResult(ID,UserID)
			SELECT distinct 
			ID,@UserId
			FROM CTE
			where id is not null


		EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''
		END
		

			ELSE IF @Condition = 8
			
			BEGIN
			PRINT @Condition
		
			INSERT INTO CompanySearchResult (Id,UserID)
			SELECT distinct
				O.ID,@UserId 
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN Organization O ON O.Id = MP.OrganizationID
			INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
			INNER JOIN #RegionIds R ON R.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
	 WHERE
            (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR MP.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR MP.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
	EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''
			END
			ELSE IF @Condition = 9
	BEGIN
	PRINT @Condition


	--;WITH CTE AS (
	--SELECT distinct
	--			MP.OrganizationID
	--		FROM 
	--		MASTER.PersonaData MP WITH (NOLOCK)
	--		INNER JOIN #Functionalities F ON F.value = MP.TechTeamIntentID
	--		),CTE1 AS (
	--		SELECT distinct
	--			MP.OrganizationID
	--		FROM 
	--		MASTER.PersonaData MP WITH (NOLOCK)
	--		INNER join #TechnologyNames T ON T.value = MP.TechTeamIntentID
	--		INNER JOIN CTE C ON C.OrganizationID = MP.OrganizationID
	--		),CTE2 AS (
	--		SELECT distinct
	--			MP.OrganizationID
	--		FROM 
	--		MASTER.PersonaData MP WITH (NOLOCK)
	--		INNER JOIN #TeamNames TE ON TE.value = MP.TechTeamIntentID
	--		INNER JOIN CTE1 C ON C.OrganizationID = MP.OrganizationID)
	--		INSERT INTO CompanySearchResult(ID,UserID)
	--		SELECT distinct
	--			MP.OrganizationID,@UserId
	--		FROM 
	--		MASTER.PersonaData MP WITH (NOLOCK)
	--		INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
	--		INNER JOIN CTE2 C ON C.OrganizationID = MP.OrganizationID
	--		INNER JOIN Organization O ON O.Id = MP.OrganizationID
	--	WHERE	            (@EmployeeCounts = ''
 --           OR O.EmployeeCount IN (SELECT
 --               value
 --           FROM STRING_SPLIT(@EmployeeCounts, ',')) )
 --           AND (@Revenues = ''
 --           OR O.Revenue IN (SELECT
 --               value
 --           FROM STRING_SPLIT(@Revenues, ',')) )
	--		AND (@CountryIds = ''
 --           OR O.CountryId IN (SELECT
 --               value
 --           FROM STRING_SPLIT(@CountryIds, ',')) )
	--		AND (@IndustryIds = ''
 --           OR O.IndustryId IN (SELECT
 --               value
 --           FROM STRING_SPLIT(@IndustryIds, ',')) )
	
	
		
	SELECT distinct
				MP.OrganizationID INTO #DFunc
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN #Functionalities F ON F.value = MP.TechTeamIntentID
			
			
			
			SELECT distinct
				MP.OrganizationID INTO #DTech
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER join #TechnologyNames T ON T.value = MP.TechTeamIntentID
			
		
			SELECT distinct
				MP.OrganizationID INTO #DTeam
			FROM 
			MASTER.PersonaData MP WITH (NOLOCK)
			INNER JOIN #TeamNames TE ON TE.value = MP.TechTeamIntentID
			

	--		INSERT INTO CompanySearchResult (Id,UserID)
	--SELECT DISTINCT O.Id,@UserId
	--from  #DatasIntent DI
	--FULL OUTER JOIN #DatasTeam DT ON DT.OrganizationId = DI.OrganizationId
	--FULL OUTER JOIN #DatasTech DTE ON DTE.OrganizationId = DT.OrganizationId
	--INNER JOIN Organization O ON (O.Id = DI.OrganizationId OR O.ID = DT.OrganizationId OR O.Id = DTE.OrganizationId) 


			INSERT INTO CompanySearchResult(ID,UserID)
			SELECT DISTINCT O.Id ,@UserId
			FROM #DFunc DF
			INNER JOIN #DTeam DT ON DF.OrganizationID = DT.OrganizationID
			INNER JOIN #DTech DTE ON DTE.OrganizationID = DT.OrganizationID
			INNER JOIN Organization O ON (O.Id = DF.OrganizationID AND O.Id = DT.OrganizationID AND O.Id = DTE.OrganizationID )

			INNER JOIN MASTER.PersonaData MP ON MP.OrganizationID = O.Id
			INNER JOIN #RegionIds R ON R.value = MP.RegionID
			INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
			--INNER JOIN Country C ON C.ID = O.CountryId
			--INNER JOIN Industry I ON I.Id = O.IndustryId
				WHERE
				--C.IsRegion IN (1,4,7,11)
				--AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1) AND
				(@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
			AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )


			EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''
			END
			ELSE 
			PRINT  ' THIS IS NEW CONDITION'

			END
