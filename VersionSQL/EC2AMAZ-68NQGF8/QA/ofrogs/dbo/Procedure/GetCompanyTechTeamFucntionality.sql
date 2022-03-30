/****** Object:  Procedure [dbo].[GetCompanyTechTeamFucntionality]    Committed by VersionSQL https://www.versionsql.com ******/

--CREATED DATE 03-DEC-20201 - KABIR - Will return Technologies, Teams, Functionalities for organizationid
-- UPDATED ON 11-JAN-2022
-- EXEC GetCompanyTechTeamFucntionality 818377,3
CREATE PROCEDURE [dbo].[GetCompanyTechTeamFucntionality]
  @OrganizationID INT,
  @UserID INT,
  @Technologies varchar(50) = '',
  @Teams varchar(50) = '',
  @Intents varchar(50) = '',
  @IsAllFilters BIT = 0
AS
BEGIN 
SET NOCOUNT ON;

DECLARE @CustomerType VARCHAR(200),
	@PersonaIds VARCHAR(200),
	@IndustryGroupIds VARCHAR(200),
	@RegionIds VARCHAR(200)


SELECT @CustomerType = CustomerType,
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM AppUser
WHERE  ID = @UserID

IF @CustomerType <> '' AND @IsAllFilters = 0 
BEGIN
print 'if'
SELECT DISTINCT 
T.Keyword Technology,TSC.StackType TechnologyCategory
FROM MASTER.TechTeamIntent MT 
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN TECHNOGRAPHICs T ON T.KEYWORD = MT.DataString
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = T.Keyword
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN PERSONA P ON P.ID = MP.PersonaID
INNER JOIN Organization O ON O.ID = T.OrganizationId
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
AND TST.IsActive = 1
AND MP.IsActive =1
AND MT.DataType = 'Technology'


SELECT DISTINCT oT.TeamName
FROM MASTER.TechTeamIntent MT 
INNER JOIN MASTER.PersonaTechTeamIntent MP 
ON MP.TechnologyFunctionalityID = MT.ID
INNER JOIN Persona P
ON MP.PersonaID = P.Id
INNER JOIN cache.OrganizationTeams Ot
ON OT.TeamName = MT.DataString
INNER JOIN Organization O ON O.Id = Ot.OrganizationId
INNER JOIN COUNTRY C ON C.ID = O.COUNTRYID
INNER JOIN INDUSTRY I ON I.ID = O.industryid
WHERE P.ID IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND O.ID = @OrganizationID
AND C.ISREGION IN (SELECT VALUE FROM 
STRING_SPLIT(@RegionIds,','))
AND I.INDUSTRYGROUPID IN (SELECT VALUE FROM 
STRING_SPLIT(@IndustryGroupIds,','))
AND  (@Teams = '' or OT.TeamName in (select value from string_split(@Teams, ',')))
AND MP.IsActive = 1
and mt.DataType = 'Team'


SELECT DISTINCT
S.Functionality,
InvestmentType,CountryName
FROM SurgeSummary S
INNER JOIN MASTER.TechTeamIntent MT ON S.Functionality = MT.DataString
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MT.ID = MP.TechnologyFunctionalityID
INNER JOIN Persona P
ON P.ID = MP.PersonaID
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
AND MP.IsActive = 1 AND MT.DataType = 'Intent'


END
ELSE
BEGIN
print 'else'
SELECT DISTINCT 
T.Keyword Technology,TSC.StackType TechnologyCategory
FROM TECHNOGRAPHICS T
INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = T.Keyword
INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
INNER JOIN MASTER.TechTeamIntent MT on MT.DataString = TST.StackTechnologyName
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
WHERE T.ORGANIZATIONID = @OrganizationID 
AND TST.IsActive =1 AND MP.IsActive = 1
AND  (@Technologies = '' or T.keyword in (select value from string_split(@Technologies, ',')))
AND MT.DataType = 'Technology'


SELECT DISTINCT T.TeamName
FROM cache.OrganizationTeaMs T
INNER JOIN ORGANIZATION O  ON O.ID = T.ORGANIZATIONID
INNER JOIN MASTER.TechTeamIntent MT on MT.DataString = t.TeamName
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
LEFT JOIN Country C ON C.ID = T.COUNTRYID
WHERE ORGANIZATIONID = @OrganizationID AND O.ID = @OrganizationID
AND  (@Teams = '' or T.TeamName in (select value from string_split(@Teams, ',')))
AND MT.DataType = 'Team' AND MP.IsActive = 1 

SELECT DISTINCT 
Functionality,InvestmentType,CountryName
FROM SurgeSummary S
INNER JOIN MASTER.TechTeamIntent MT on MT.DataString = S.Functionality
INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
WHERE ORGANIZATIONID = @OrganizationID
AND  (@Intents = '' or Functionality in (select value from string_split(@Intents, ',')))
AND MP.IsActive = 1 AND MT.DataType = 'Intent'
END
END
