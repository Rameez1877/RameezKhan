/****** Object:  Procedure [dbo].[GetCompanyTechTeamFucntionality_new]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-20201 - KABIR - Will return Technologies, Teams, Functionalities for organizationid
-- EXEC GetCompanyTechTeamFucntionality 818377,3
CREATE PROCEDURE [dbo].[GetCompanyTechTeamFucntionality_new]
  @OrganizationID INT,
  @UserID INT,
  @Technologies varchar(50) = '',
  @Teams varchar(50) = '',
  @Intents varchar(50) = '',
  @TargetPersonaId int = 0,
  @IsAllFilter BIT = 0
AS
BEGIN 
SET NOCOUNT ON;

DECLARE @CustomerType VARCHAR(200),
	@PersonaIds VARCHAR(200),
	@IndustryGroupIds VARCHAR(200),
	@RegionIds VARCHAR(200)

If @TargetPersonaId <> 0 
begin
	select @Technologies = Technologies, @Teams = Segment, @Intents = Intent From TargetPersona where Id = @TargetPersonaId
end


SELECT @CustomerType = CustomerType,
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM AppUser
WHERE  ID = @UserID

IF @CustomerType <> '' AND @IsAllFilter = 0 
BEGIN
print 'if'
SELECT DISTINCT 
T.Keyword Technology,TSC.StackType TechnologyCategory
FROM AdoptionFrameworkTechnologyCategory A
INNER JOIN TECHSTACKSUBCATEGORY TSC ON TSC.ID = A.TECHNOLOGYCATEGORYID
INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKSUBCATEGORYID = TSC.ID
INNER JOIN TECHNOGRAPHICS T ON T.KEYWORD = TST.STACKTECHNOLOGYNAME
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
AND  (@Technologies = '' or T.keyword in (select value from string_split(@Technologies, ',')))

SELECT DISTINCT oT.TeamName
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
AND  (@Teams = '' or OT.TeamName in (select value from string_split(@Teams, ',')))

SELECT DISTINCT
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
AND  (@Intents = '' or S.Functionality in (select value from string_split(@Intents, ',')))
END

ELSE
BEGIN
print 'else'
SELECT DISTINCT 
T.Keyword Technology,TSC.StackType TechnologyCategory
FROM TECHNOGRAPHICS T
INNER JOIN TECHSTACKTECHNOLOGY TST ON TST.STACKTECHNOLOGYNAME = T.KEYWORD
INNER JOIN TECHSTACKSUBCATEGORY TSC ON TSC.ID = TST.STACKSUBCATEGORYID
WHERE T.ORGANIZATIONID = @OrganizationID 
AND TST.IsActive =1 
AND  (@Technologies = '' or T.keyword in (select value from string_split(@Technologies, ',')))

SELECT DISTINCT T.TeamName
FROM cache.OrganizationTeaMs T
INNER JOIN ORGANIZATION O  ON O.ID = T.ORGANIZATIONID
LEFT JOIN Country C ON C.ID = T.COUNTRYID
WHERE ORGANIZATIONID = @OrganizationID AND O.ID = @OrganizationID
AND  (@Teams = '' or T.TeamName in (select value from string_split(@Teams, ',')))


SELECT DISTINCT 
Functionality,InvestmentType,CountryName
FROM SurgeSummary
WHERE ORGANIZATIONID = @OrganizationID
AND  (@Intents = '' or Functionality in (select value from string_split(@Intents, ',')))

END
END
