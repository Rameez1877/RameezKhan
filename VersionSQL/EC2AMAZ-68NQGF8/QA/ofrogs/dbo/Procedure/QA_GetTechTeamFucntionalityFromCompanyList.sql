/****** Object:  Procedure [dbo].[QA_GetTechTeamFucntionalityFromCompanyList]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-20201 - KABIR - Will return Technologies, Teams, Functionalities for organizationid
-- EXEC [GetTechTeamFucntionalityFromCompanyList] 6663,159,30017
 CREATE PROCEDURE [dbo].[QA_GetTechTeamFucntionalityFromCompanyList]
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
	@Limit INT, 
	@Intent VARCHAR(500), 
	@Technology VARCHAR(500),
	@Team VARCHAR(500),
	@HasCustom int
	

SELECT 
@AppRoleID = AppRoleID, @HasCustom = HasCustomPersona
FROM AppUser
WHERE  ID = @UserID

SET @Limit = IIF(@AppRoleID = 3, 50,200)

SELECT 
@CustomerType = CustomerType, 
@Intent = Intent, 
@Technology  = Technologies, 
@Team = Segment
FROM TargetPersona
WHERE ID = @TargetPersonaId AND CreatedBy = @UserID



--SELECT @CustomerType = CustomerType,
--@PersonaIds = PersonaIds,
--@IndustryGroupIds = IndustryGroupIds,
--@RegionIds = RegionIds
--FROM AppUser
--WHERE  ID = @UserID



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
 print '@Technology = IF  '
 SELECT DISTINCT  TOP (@Limit)
T.Keyword as Technology,TST.SubCategory as TechnologyCategory
FROM AdoptionFrameworkTechnologyCategory A
--INNER JOIN TECHSTACKSUBCATEGORY TSC ON TSC.ID = A.TECHNOLOGYCATEGORYID
--INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
INNER JOIN Technologies TST ON TST.SubCategoryID = A.TechnologyCategoryId
INNER JOIN TECHNOGRAPHICS T ON T.KEYWORD = TST.Technology
--INNER JOIN PERSONA P ON P.NAME = A.CATEGORY
INNER JOIN ORGANIZATION O ON O.ID = T.ORGANIZATIONID
--INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
--INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE 
T.ORGANIZATIONID = @OrganizationID
--AND P.ID IN (SELECT VALUE FROM 
--STRING_SPLIT(@PersonaIds,','))
--AND C.ISREGION IN (SELECT VALUE FROM 
--STRING_SPLIT(@RegionIds,','))
--AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
--STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE IF @Technology = '' AND @CustomerType <> ''
BEGIN
 SELECT DISTINCT  TOP (@Limit)
T.Keyword as Technology,TST.SubCategory as TechnologyCategory
FROM AdoptionFrameworkTechnologyCategory A
INNER JOIN Technologies TST ON TST.SubCategoryID = A.TechnologyCategoryId
INNER JOIN TECHNOGRAPHICS T ON T.KEYWORD = TST.Technology
INNER JOIN PERSONA P ON P.NAME = A.CATEGORY
INNER JOIN ORGANIZATION O ON O.ID = T.ORGANIZATIONID
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE 
T.ORGANIZATIONID = @OrganizationID
AND P.ID IN (SELECT VALUE FROM 
STRING_SPLIT(@PersonaIds,','))
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE
BEGIN

print '@Technology = else'
SELECT DISTINCT  TOP (@Limit) 
T.Technology as Technology,
T.SubCategory  as TechnologyCategory
FROM Technologies T
WHERE T.Technology IN (SELECT VALUE FROM string_split(@Technology,','))

END

IF @Team = '' AND @CustomerType = ''
BEGIN
PRINT '@TEAM = IF'
SELECT DISTINCT TOP (@Limit)
oT.TeamName
FROM AdoptionFramework A
INNER JOIN Persona P
ON A.CATEGORY = P.Name
INNER JOIN McDecisionmaker M
ON M.NAME = A.FUNCTIONALITY
INNER JOIN cache.OrganizationTeams Ot
ON OT.TeamName = A.FUNCTIONALITY
INNER JOIN Organization O ON O.Id = Ot.OrganizationId
--INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
--INNER JOIN INDUSTRY I ON I.ID = O.industryid
WHERE 
--P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
 M.ISACTIVE = 1 AND M.ISOFLIST = 1
AND O.ID = @OrganizationID
--AND C.ISREGION IN (SELECT VALUE FROM 
--STRING_SPLIT(@RegionIds,','))
--AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
--STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE IF @Team = '' AND @CustomerType <> ''
BEGIN

SELECT DISTINCT TOP (@Limit)
oT.TeamName
FROM AdoptionFramework A
INNER JOIN Persona P
ON A.CATEGORY = P.Name
INNER JOIN McDecisionmaker M
ON M.NAME = A.FUNCTIONALITY
INNER JOIN cache.OrganizationTeams Ot
ON OT.TeamName = A.FUNCTIONALITY
INNER JOIN Organization O ON O.Id = Ot.OrganizationId
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.industryid
WHERE 
P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,',')) AND
M.ISACTIVE = 1 AND M.ISOFLIST = 1
AND O.ID = @OrganizationID
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE
BEGIN

PRINT '@TEAM = ELSE'
SELECT VALUE AS TeamName INTO #TEAM
FROM 
string_split(@Team,',')

 DECLARE @Count INT
 
 SET @COUNT = (SELECT COUNT(*) FROM #TEAM)

 IF @TEAM = ''
 BEGIN
 DELETE FROM #TEAM
 SELECT * FROM #TEAM
 END
 ELSE 
 BEGIN
 SELECT * FROM #TEAM
 
 END
 
 END


IF @Intent = '' AND @CustomerType = ''
BEGIN

PRINT '@INTENT = IF'
SELECT DISTINCT TOP (@Limit)
S.Functionality,
InvestmentType,CountryName
FROM SurgeSummary S
INNER JOIN AdoptionFramework A
ON S.functionality = A.functionality
--INNER JOIN Persona P
--ON P.NAME = A.Category
INNER JOIN Organization O ON O.Id = S.OrganizationId
--INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
--INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE S.ORGANIZATIONID = @OrganizationID
--AND P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
--AND C.ISREGION IN (SELECT VALUE FROM 
--STRING_SPLIT(@RegionIds,','))
--AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
--STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE IF @Intent = '' AND @CustomerType <> ''
BEGIN

SELECT DISTINCT TOP (@Limit)
S.Functionality,
InvestmentType,CountryName
FROM SurgeSummary S
INNER JOIN AdoptionFramework A
ON S.functionality = A.functionality
INNER JOIN Persona P
ON P.NAME = A.Category
INNER JOIN Organization O ON O.Id = S.OrganizationId
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE S.ORGANIZATIONID = @OrganizationID
AND P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))

END
ELSE
BEGIN

PRINT '@INTENT = ELSE'
SELECT DISTINCT  TOP (@Limit) 
S.Functionality, 
S.InvestmentType,
S.CountryName   
FROM TargetPersonaOrganization T
INNER JOIN SURGESUMMARY S
ON T.ORGANIZATIONID = S.ORGANIZATIONID
WHERE TARGETPERSONAID = @TargetPersonaId
AND S.Functionality IN (SELECT VALUE FROM string_split(@Intent,','))

END

END

 
IF @Intent = '' AND @Technology = '' AND @Team = '' AND @CustomerType = ''
BEGIN

PRINT 'ELSE IF @Intent =  AND @Technology =  AND @Team =  AND @CustomerType = '



SELECT DISTINCT TOP (@Limit) 
T.Keyword as Technology,TST.SubCategory as TechnologyCategory
FROM TECHNOGRAPHICS T
INNER JOIN Technologies TST
ON T.Keyword = TST.Technology
WHERE T.ORGANIZATIONID = @OrganizationID 
AND TST.IsActive =1 

SELECT DISTINCT TOP (@Limit) T.TeamName
FROM cache.OrganizationTeaMs T
INNER JOIN ORGANIZATION O  ON O.ID = T.ORGANIZATIONID
LEFT JOIN Country C ON C.ID = T.COUNTRYID
WHERE ORGANIZATIONID = @OrganizationID AND O.ID = @OrganizationID


SELECT DISTINCT TOP (@Limit)
Functionality,InvestmentType,CountryName
FROM SurgeSummary
WHERE ORGANIZATIONID = @OrganizationID

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

SELECT DISTINCT  TOP (@Limit)
T.Keyword as Technology,TST.SubCategory as TechnologyCategory
FROM AdoptionFrameworkTechnologyCategory A
INNER JOIN Technologies TST ON TST.SubCategoryID = A.TechnologyCategoryId
INNER JOIN TECHNOGRAPHICS T ON T.KEYWORD = TST.Technology
INNER JOIN PERSONA P ON P.NAME = A.CATEGORY
INNER JOIN ORGANIZATION O ON O.ID = T.ORGANIZATIONID
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE 
T.ORGANIZATIONID = @OrganizationID
AND P.ID IN (SELECT VALUE FROM 
STRING_SPLIT(@PersonaIds,','))
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))

SELECT DISTINCT TOP (@Limit)
oT.TeamName
FROM AdoptionFramework A
INNER JOIN Persona P
ON A.CATEGORY = P.Name
INNER JOIN McDecisionmaker M
ON M.NAME = A.FUNCTIONALITY
INNER JOIN cache.OrganizationTeams Ot
ON OT.TeamName = A.FUNCTIONALITY
INNER JOIN Organization O ON O.Id = Ot.OrganizationId
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.industryid
WHERE P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND M.ISACTIVE = 1 AND M.ISOFLIST = 1
AND O.ID = @OrganizationID
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))

SELECT DISTINCT TOP (@Limit)
S.Functionality,
InvestmentType,CountryName
FROM SurgeSummary S
INNER JOIN AdoptionFramework A
ON S.functionality = A.functionality
INNER JOIN Persona P
ON P.NAME = A.Category
INNER JOIN Organization O ON O.Id = S.OrganizationId
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.INDUSTRYID
WHERE S.ORGANIZATIONID = @OrganizationID
AND P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))
END

IF (@PersonaIds = '' OR @PersonaIds IS NULL) AND (@HasCustom = 0 OR @HasCustom IS NULL 
OR @HasCustom = '')
BEGIN
SELECT DISTINCT  TOP (@Limit)
'' AS  Technology,'' AS  TechnologyCategory

SELECT
'' AS TeamName

SELECT
'' AS  Functionality,
'' AS  InvestmentType, '' AS  CountryName
END


END
