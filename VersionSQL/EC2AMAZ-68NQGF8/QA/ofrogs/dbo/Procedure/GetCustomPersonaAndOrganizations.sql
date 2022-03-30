/****** Object:  Procedure [dbo].[GetCustomPersonaAndOrganizations]    Committed by VersionSQL https://www.versionsql.com ******/

	-- 14-DEC-2021 - Kabir - When user has no configuration this SP will populate data and Custom Personas 
	-- EXEC [GetCustomPersonaAndOrganizations] 159,'Azure','OmniChannel','Android','','','>100K',''
	-- EXEC [GetCustomPersonaAndOrganizations] 5865,'','','AZURE','101','','',''
	CREATE PROCEDURE [dbo].[GetCustomPersonaAndOrganizations]
	@UserId int,
	@IndustryIds  VARCHAR(500) = '',
	@CountryIds  VARCHAR(500) = '',
	@EmployeeCounts  VARCHAR(500) = '',
	@Revenues  VARCHAR(5000) = '',
	@TechnologyNames VARCHAR(5000) = '',
	@TeamNames VARCHAR(8000) = '',
	@Functionalities  VARCHAR(500) = '',
	@GicCountryIds varchar(8000) = '',
	@IsSearchAll bit = 0

	AS
	BEGIN
    SET NOCOUNT ON
	DELETE FROM CompanySearchResult WHERE UserID = @UserId

	Declare @AppRoleID INT
	--@Limit INT

	SELECT @AppRoleID = AppRoleID
	FROM AppUser 
	WHERE ID = @UserID

	--SET @Limit = IIF(@AppRoleID = 3,200,5000)


	IF @TechnologyNames <> '' OR @TeamNames <> '' OR @Functionalities <> ''
	BEGIN
    CREATE TABLE #Datas(DataType VARCHAR(200),DataValue INT,DataString VARCHAR(200))

	-- INSERT INTO #Datas(DataType,DataValue,DataString)
	INSERT INTO #Datas(DataValue)
	SELECT -- DISTINCT TOP (@Limit)
	--'Technology',
	OrganizationId--,Keyword
	FROM Technographics T
	INNER JOIN Organization O 
	ON O.ID = T.OrganizationId
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	WHERE 
	(Keyword in (SELECT VALUE FROM string_split(@TechnologyNames,',')))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))


	-- INSERT INTO #Datas(DataType,DataValue,DataString)
	INSERT INTO #Datas(DataValue)
	SELECT -- DISTINCT TOP (@Limit)
	--'Team',
	OrganizationId--,TeamName
	FROM cache.OrganizationTeams OT
	INNER JOIN Organization O 
	ON O.ID = OT.OrganizationId
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	WHERE 
	TeamName in (SELECT VALUE FROM string_split(@TeamNames,','))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))


	-- INSERT INTO #Datas(DataType,DataValue,DataString)
	INSERT INTO #Datas(DataValue)
	SELECT -- DISTINCT  TOP (@Limit)
	--'Intent',
	OrganizationId--,Functionality
	FROM SurgeSummary S
	INNER JOIN Organization O 
	ON O.ID = S.OrganizationId
	INNER JOIN Country C ON C.ID = O.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	WHERE 
	Functionality in (SELECT VALUE FROM string_split(@Functionalities,','))
	AND C.IsRegion IN (1,11,4,7)
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND (@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))

	INSERT INTO CompanySearchResult(ID,UserID)
	SELECT DISTINCT --TOP (@Limit)
	O.Id,@UserId
	FROM #Datas D
	INNER JOIN Organization O
	ON D.DataValue = O.id
	EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''

	END

	ELSE IF @TechnologyNames = '' AND @TeamNames = '' AND @Functionalities = '' AND @CountryIds <> '' OR
	@IndustryIds <> '' OR @EmployeeCounts <> '' OR @Revenues <> '' 
	BEGIN
	INSERT INTO CompanySearchResult(ID,UserID)
	SELECT DISTINCT --TOP (@Limit)
	O.Id,@UserId
	FROM Organization O 
	INNER JOIN Industry I ON I.ID = O.INDUSTRYID
	INNER JOIN Country C ON C.ID = O.COUNTRYID
	WHERE 
	(@CountryIds = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
	EXEC [QA_GetCompanySearchResult] @UserID,0,10,'','','','',''

	END
	END
