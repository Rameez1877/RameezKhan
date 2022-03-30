/****** Object:  Procedure [dbo].[GetTechTeamFucntionalityFromCompanyList]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-20201 - KABIR - Will return Technologies, Teams, Functionalities for organizationid
-- EXEC [GetTechTeamFucntionalityFromCompanyList] 6663,159,30017
 CREATE PROCEDURE [dbo].[GetTechTeamFucntionalityFromCompanyList]
  @OrganizationID INT,
  @UserID INT,
  @TargetPersonaId int 

AS
BEGIN 
SET NOCOUNT ON;
DECLARE @CustomerType VARCHAR(200),
	@PersonaIds VARCHAR(200),
	@IndustryGroupIds VARCHAR(200),
	@RegionIds VARCHAR(200),
	@AppRoleID INT,
	--@Limit INT, 
	@Intent VARCHAR(500), 
	@Technology VARCHAR(500),
	@Team VARCHAR(500),
	@HasCustom int
	

SELECT 
@AppRoleID = AppRoleID, @HasCustom = HasCustomPersona
FROM AppUser
WHERE  ID = @UserID

--SET @Limit = IIF(@AppRoleID = 3, 50,200)

SELECT 
@CustomerType = CustomerType, 
@Intent = Intent, 
@Technology  = Technologies, 
@Team = Segment
FROM TargetPersona
WHERE ID = @TargetPersonaId AND CreatedBy = @UserID



SELECT @CustomerType = CustomerType,
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM AppUser
WHERE  ID = @UserID



IF @Intent <> '' OR @Technology <> '' OR @Team <> ''
BEGIN

PRINT '@Intent <>  OR @Technology <>  OR @Team <>'

SELECT
@CustomerType = CustomerType,
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM TargetPersona
WHERE  ID = @TargetPersonaId
AND CreatedBy = @UserID


 IF @Technology = '' AND @CustomerType = ''
 BEGIN
 print '@Technology = IF'
 SELECT DISTINCT  --TOP (@Limit)
TST.StackTechnologyName as Technology,TSC.StackType as TechnologyCategory
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = MT.DataString
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN Technographics T ON T.Keyword = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 AND TST.IsActive = 1 AND MT.DataType = 'Technology'
AND TST.StackTechnologyName IS NOT NULL AND TST.StackTechnologyName <> ''


END
ELSE IF @Technology = '' AND @CustomerType <> ''
BEGIN
 SELECT DISTINCT -- TOP (@Limit)
TST.StackTechnologyName as Technology,TSC.StackType as TechnologyCategory
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = MT.DataString
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN Technographics T ON T.Keyword = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,',')) AND MP.IsActive = 1 AND TST.IsActive = 1
AND MT.DataType = 'Technology'
AND TST.StackTechnologyName IS NOT NULL AND TST.StackTechnologyName <> ''


END
ELSE
BEGIN

print '@Technology = else'
SELECT DISTINCT  --TOP (@Limit) 
TST.StackTechnologyName as Technology,
TSC.StackType  as TechnologyCategory
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = MT.DataString
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN Technographics T ON T.Keyword = MT.DataString
INNER JOIN Organization O ON O.Id = T.OrganizationId
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.ID = O.IndustryId
WHERE --TST.StackTechnologyName IN (SELECT VALUE FROM string_split(@Technology,',')) 
--AND
MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) 
AND TST.StackTechnologyName IS NOT NULL AND TST.StackTechnologyName <> ''
AND MP.IsActive =1 AND TST.IsActive = 1 AND MT.DataType = 'Technology'
AND TST.StackTechnologyName IN (SELECT VALUE FROM string_split(@Technology,','))

END

IF @Team = '' AND @CustomerType = ''
BEGIN
PRINT '@TEAM = IF'
SELECT DISTINCT -- TOP (@Limit)
T.TeamName 
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN CACHE.OrganizationTeams T ON T.TeamName = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 AND MT.DataType = 'Team'
and t.TeamName IS NOT NULL AND T.TeamName <> ''

END
ELSE IF @Team = '' AND @CustomerType <> ''
BEGIN
SELECT DISTINCT -- TOP (@Limit)
T.TeamName 
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN CACHE.OrganizationTeams T ON T.TeamName = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,',')) AND MP.IsActive = 1 
AND MT.DataType = 'Team'
and t.TeamName IS NOT NULL AND T.TeamName <> ''


END
ELSE
BEGIN

SELECT DISTINCT -- TOP (@Limit)
T.TeamName 
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN CACHE.OrganizationTeams T ON T.TeamName = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.ID = O.IndustryId
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) 
AND MT.DataType = 'Team'
 and t.TeamName IS NOT NULL AND T.TeamName <> ''
 AND T.TeamName IN (SELECT VALUE FROM string_split(@Team,','))

 END
 



IF @Intent = '' AND @CustomerType = ''
BEGIN

PRINT '@INTENT = IF'

SELECT DISTINCT -- TOP (@Limit)
S.Functionality,S.InvestmentType,S.CountryName
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN SurgeSummary S ON S.Functionality = MT.DataString
INNER JOIN Organization O ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
S.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 AND MT.DataType = 'Intent'
 and S.Functionality IS NOT NULL AND S.Functionality <> ''

END
ELSE IF @Intent = '' AND @CustomerType <> ''
BEGIN

SELECT DISTINCT -- TOP (@Limit)
S.Functionality,S.InvestmentType,S.CountryName
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN SurgeSummary S ON S.Functionality = MT.DataString
INNER JOIN Organization O ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
S.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN  (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN  (SELECT VALUE FROM string_split(@RegionIds,',')) 
AND MP.IsActive = 1  AND MT.DataType = 'Intent'
 and S.Functionality IS NOT NULL AND S.Functionality <> ''

END
ELSE
BEGIN

PRINT '@INTENT = ELSE'
SELECT DISTINCT -- TOP (@Limit)
S.Functionality,S.InvestmentType,S.CountryName
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN SurgeSummary S ON S.Functionality = MT.DataString
INNER JOIN Organization O ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
S.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MT.DataType = 'Intent'
 and S.Functionality IS NOT NULL AND S.Functionality <> ''
 AND S.Functionality IN (SELECT VALUE FROM string_split(@Intent,','))
END

END

 
IF @Intent = '' AND @Technology = '' AND @Team = '' AND @CustomerType = ''
BEGIN

PRINT 'ELSE IF @Intent =  AND @Technology =  AND @Team =  AND @CustomerType = '



SELECT DISTINCT  --TOP (@Limit) 
TST.StackTechnologyName as Technology,
TSC.StackType  as TechnologyCategory
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = MT.DataString
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN Technographics T ON T.Keyword = MT.DataString
INNER JOIN Organization O ON O.Id = T.OrganizationId
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.ID = O.IndustryId
WHERE --TST.StackTechnologyName IN (SELECT VALUE FROM string_split(@Technology,',')) 
--AND
MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 
AND TST.StackTechnologyName IS NOT NULL AND TST.StackTechnologyName <> ''
AND MP.IsActive =1 AND TST.IsActive = 1 AND MT.DataType = 'Technology'

SELECT DISTINCT -- TOP (@Limit)
T.TeamName 
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN CACHE.OrganizationTeams T ON T.TeamName = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.ID = O.IndustryId
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 
AND MT.DataType = 'Team'
AND t.TeamName IS NOT NULL AND T.TeamName <> ''


SELECT DISTINCT -- TOP (@Limit)
S.Functionality,S.InvestmentType,S.CountryName
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN SurgeSummary S ON S.Functionality = MT.DataString
INNER JOIN Organization O ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
S.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT ID FROM Persona WHERE ISACTIVE = 1 UNION SELECT ID FROM Persona WHERE ID = 59 )
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE ISACTIVE = 1)
AND C.IsRegion IN (1,4,7,11) AND MP.IsActive = 1 AND MT.DataType = 'Intent'
and S.Functionality IS NOT NULL AND S.Functionality <> ''

END

ELSE IF @Intent = '' AND @Technology = '' AND @Team = '' AND @CustomerType <> ''
BEGIN

PRINT 'ELSE IF @Intent =  AND @Technology =  AND @Team =  AND @CustomerType <> '
SELECT
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM TargetPersona
WHERE  ID = @TargetPersonaId
AND CreatedBy = @UserID


SELECT DISTINCT  --TOP (@Limit) 
TST.StackTechnologyName as Technology,
TSC.StackType  as TechnologyCategory
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = MT.DataString
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN Technographics T ON T.Keyword = MT.DataString
INNER JOIN Organization O ON O.Id = T.OrganizationId
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.ID = O.IndustryId
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,',')) AND MP.IsActive = 1 
AND MT.DataType = 'Technology'
and TST.StackTechnologyName IS NOT NULL AND TST.StackTechnologyName <> '' AND TST.IsActive = 1





 SELECT DISTINCT -- TOP (@Limit)
T.TeamName 
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN CACHE.OrganizationTeams T ON T.TeamName = MT.DataString
INNER JOIN Organization O ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
T.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,',')) AND MP.IsActive = 1 
AND MT.DataType = 'Team'
and t.TeamName IS NOT NULL AND T.TeamName <> ''



SELECT DISTINCT -- TOP (@Limit)
S.Functionality,S.InvestmentType,S.CountryName
FROM master.TechTeamIntent MT
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN SurgeSummary S ON S.Functionality = MT.DataString
INNER JOIN Organization O ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.COUNTRYID
INNER JOIN Industry I ON I.ID = O.INDUSTRYID
INNER JOIN TargetPersonaOrganization TPO ON TPO.OrganizationId = O.Id
WHERE 
S.ORGANIZATIONID = @OrganizationID AND TPO.TargetPersonaId = @TargetPersonaId
AND MP.PersonaID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND I.IndustryGroupId IN  (SELECT VALUE FROM string_split(@IndustryGroupIds,','))
AND C.IsRegion IN  (SELECT VALUE FROM string_split(@RegionIds,',')) 
AND MP.IsActive = 1  AND MT.DataType = 'Intent'
 and S.Functionality IS NOT NULL AND S.Functionality <> ''

END

IF (@PersonaIds = '' OR @PersonaIds IS NULL) AND (@HasCustom = 0 OR @HasCustom IS NULL 
OR @HasCustom = '')
BEGIN
SELECT DISTINCT -- TOP (@Limit)
'' AS  Technology,'' AS  TechnologyCategory

SELECT
'' AS TeamName

SELECT
'' AS  Functionality,
'' AS  InvestmentType, '' AS  CountryName
END


END
