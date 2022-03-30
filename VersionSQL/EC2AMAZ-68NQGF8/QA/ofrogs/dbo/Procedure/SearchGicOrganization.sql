/****** Object:  Procedure [dbo].[SearchGicOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

/*
exec [QA_SearchGicOrganizationWithPagination]
159,    -- @UserId int,
'',   -- @IndustryIds varchar(max) = '',
'',   -- @CountryIds varchar(max) = '',
'',   -- @EmployeeCounts varchar(max) = '',
'',   -- @Revenues varchar(8000) = '',
'',   -- @TechnologyNames varchar(8000) = '',
'',   -- @TeamNames varchar(8000) = '',
'',	-- @Functionalities varchar(8000) = '',
'13',	-- @GicCountryIds varchar(8000) = '',
0	-- @IsSearchAll BIT = 0
*/
CREATE PROCEDURE [dbo].[SearchGicOrganization]
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

AS
BEGIN
DELETE FROM CompanySearchResult WHERE UserID = @UserId


DECLARE @AppRoleId INT, @Condition INT

SELECT @AppRoleId = AppRoleId
FROM AppUser
WHERE ID = @UserId

SET @Condition = IIF(@TechnologyNames <> '' OR @TeamNames <> '',1,@Condition)
SET @Condition = IIF((@TechnologyNames = '' AND @TeamNames = '') AND
	(@IndustryIds <> '' OR @EmployeeCounts <> '' OR @Revenues <> ''  OR @GicCountryIds <> ''),2,@Condition)

IF @Condition = 1
	BEGIN
	PRINT @Condition
    CREATE TABLE #Datas(DataType VARCHAR(200),DataValue INT,DataString VARCHAR(200))

	INSERT INTO #Datas(
	DataValue
	)
	SELECT 
	G.OrganizationID
	FROM GicOrganization G
	INNER JOIN Technographics T ON G.OrganizationID = T.OrganizationId
	INNER JOIN Organization O 
	ON O.ID = T.OrganizationId
	INNER JOIN Country C ON C.ID = G.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = T.Keyword
	INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
	WHERE 
	 MP.IsActive = 1 AND  MP.PersonaID <> 59 AND MT.DataType = 'Technology' AND 
	(MT.ID in (SELECT VALUE FROM string_split(@TechnologyNames,',')))
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND  (@GicCountryIds = '' OR G.CountryId IN (SELECT VALUE FROM string_split(@GicCountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))


	INSERT INTO #Datas(
	DataValue
	)
	SELECT 
	G.OrganizationID
	FROM GicOrganization G
	INNER JOIN cache.OrganizationTeams OT
	ON G.OrganizationID = OT.OrganizationId
	INNER JOIN Organization O 
	ON O.ID = OT.OrganizationId
	INNER JOIN Country C ON C.ID = G.CountryID
	INNER JOIN Industry I ON I.ID = O.IndustryID
	INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = OT.TeamName
	INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
	WHERE 
	 MP.IsActive = 1 AND  MP.PersonaID <> 59 AND MT.DataType = 'Team' AND 
	MT.ID in (SELECT VALUE FROM string_split(@TeamNames,','))
	AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
	AND  (@GicCountryIds = '' OR G.CountryId IN (SELECT VALUE FROM string_split(@GicCountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))


	
	INSERT INTO CompanySearchResult(ID,UserID)
	SELECT DISTINCT 
	O.Id,@UserId
	FROM #Datas D
	INNER JOIN Organization O
	ON D.DataValue = O.id

	EXEC [GetCompanySearchResult] @UserID,0,10,'','','',''
	END

	ELSE IF @Condition = 2
	BEGIN
	PRINT @Condition
	INSERT INTO CompanySearchResult(ID,UserID)
	SELECT DISTINCT 
	O.Id,@UserId
	FROM GicOrganization G
	INNER JOIN Organization O ON G.OrganizationID =O.Id
	INNER JOIN Industry I ON I.ID = O.INDUSTRYID
	INNER JOIN Country C ON C.ID = G.CountryID
	WHERE 
	  (@GicCountryIds = '' OR  G.CountryId IN (SELECT VALUE FROM string_split(@GicCountryIds,',')))
	AND (@IndustryIds = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryIds,',')))
	AND (@Revenues = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenues,',')))
	AND (@EmployeeCounts = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCounts,',')))
	EXEC [GetCompanySearchResult] @UserID,0,10,'','','',''


	END

END
