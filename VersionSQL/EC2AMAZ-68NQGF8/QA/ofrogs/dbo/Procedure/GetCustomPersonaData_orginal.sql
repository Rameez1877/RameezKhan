/****** Object:  Procedure [dbo].[GetCustomPersonaData_orginal]    Committed by VersionSQL https://www.versionsql.com ******/

/*

 EXEC QA_GetDashboardData 159
 EXEC QA_GetDashboardGraph 159
 SELECT * FROM UserDataContainer WHERE USERID = 159
 SELECT * FROM UserGraphContainer WHERE UserID = 159
 EXEC [QA_GetCustomPersonaData]  30017,null,null,null
 SELECT * FROM TargetPersona WHERE CreatedBy = 159
 SELECT * FROM Appuser WHERE id = 159
 SELECT * FROM PERSONA
 EXEC [QA_GetAnniversaryAndNewHireFromDashboardSummary] 159,0 -- 24sec 54rec
 EXEC [GetAnniversaryAndNewHireFromDashboardSummary] 159,0  -- 16 sec 54rec


*/
create PROCEDURE [dbo].[GetCustomPersonaData_orginal] 
 @TargetPersonaId INT
,@CustomTeamPersonaID VARCHAR(200)
,@CustomTechnologyPersonaID VARCHAR(200)	
,@CustomIntentPersonaID VARCHAR(200)

AS 
BEGIN
SET NOCOUNT ON;

	DECLARE
		@UserID INT,
		@Technology VARCHAR(2000) = '',
		@Team VARCHAR(2000) = '',
		@Intent  VARCHAR(2000) = '',
		@CountryId  VARCHAR(500) = '',
		@IndustryId  VARCHAR(500) = '',
		@EmployeeCount  VARCHAR(500) = '',
		@Revenue  VARCHAR(500) = ''

	SELECT
	  @UserID = CreatedBy,
	  @Technology = Technologies,
	  @Team = Segment,
	  @Intent = Intent,
	  @CountryId = Locations,
	  @EmployeeCount = EmployeeCounts,
	  @Revenue = Revenues
	FROM TargetPersona
	WHERE Id = @TargetPersonaId

delete from UserDataContainer where userid = @userid
delete from UserGraphContainer where userid = @userid
delete from  UserDataOrganization where userid = @userid


-- TECHNOLOGY
INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT
'Technology',OrganizationId,Keyword,@UserID,0
FROM Technographics T  WITH (NOLOCK)
INNER JOIN Organization O   WITH (NOLOCK)
ON O.ID = T.OrganizationId
INNER JOIN Country C ON C.ID = O.CountryID
INNER JOIN Industry I ON I.ID = O.IndustryID
WHERE 
(Keyword in (SELECT VALUE FROM string_split(@Technology,',')))
AND C.IsRegion IN (1,11,4,7)
AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
AND (@CountryId = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryId,',')))
AND (@IndustryId = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryId,',')))
AND (@Revenue = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenue,',')))
AND (@EmployeeCount = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCount,',')))

-- TEAM
INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT
'Team',OrganizationId,TeamName,@UserID,0
FROM cache.OrganizationTeams OT  WITH (NOLOCK)
INNER JOIN Organization O   WITH (NOLOCK)
ON O.ID = OT.OrganizationId
INNER JOIN Country C ON C.ID = O.CountryID
INNER JOIN Industry I ON I.ID = O.IndustryID
WHERE 
TeamName in (SELECT VALUE FROM string_split(@Team,','))
AND C.IsRegion IN (1,11,4,7)
AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
AND (@CountryId = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryId,',')))
AND (@IndustryId = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryId,',')))
AND (@Revenue = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenue,',')))
AND (@EmployeeCount = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCount,',')))

-- INTENT
INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT
'Intent',OrganizationId,Functionality,@UserID,0
FROM SurgeSummary S  WITH (NOLOCK)
INNER JOIN Organization O   WITH (NOLOCK)
ON O.ID = S.OrganizationId
INNER JOIN Country C ON C.ID = O.CountryID
INNER JOIN Industry I ON I.ID = O.IndustryID
WHERE 
Functionality in (SELECT VALUE FROM string_split(@Intent,','))
AND C.IsRegion IN (1,11,4,7)
AND I.IndustryGroupID IN (SELECT DISTINCT ID FROM IndustryGroup WHERE IsActive = 1)
AND (@CountryId = '' OR O.CountryId IN (SELECT VALUE FROM string_split(@CountryId,',')))
AND (@IndustryId = '' OR O.IndustryId IN (SELECT VALUE FROM string_split(@IndustryId,',')))
AND (@Revenue = '' OR O.Revenue IN (SELECT VALUE FROM string_split(@Revenue,',')))
AND (@EmployeeCount = '' OR O.EmployeeCount IN (SELECT VALUE FROM string_split(@EmployeeCount,',')))


-- RegionID
;WITH CTE AS(
SELECT DISTINCT
C.IsRegion RegionId
FROM UserDataContainer U
INNER JOIN Organization O
ON O.Id = u.OrganizationID
INNER JOIN Country C ON C.ID = O.CountryId
WHERE U.UserID = @UserID
)
UPDATE AppUser SET RegionIds = (
SELECT 
STRING_AGG(RegionId,',')
FROM CTE) WHERE ID = @UserID


-- IndustryGroupIds
;WITH CTE AS(
SELECT DISTINCT
I.IndustryGroupId IndustryGroupIds
FROM UserDataContainer U
INNER JOIN Organization O
ON O.Id = u.OrganizationID
INNER JOIN Industry I ON I.ID = O.IndustryId
WHERE U.UserID = @UserID
)
UPDATE AppUser SET IndustryGroupIds = (
SELECT 
STRING_AGG(IndustryGroupIds,',')
FROM CTE) WHERE ID = @UserID




-- CustomTechnologyPersonaID
SELECT DISTINCT
StackSubCategoryID INTO #StackSubCategoryID
FROM CustomUserData 
INNER JOIN TechStackTechnology TST WITH (NOLOCK)
ON TST.StackTechnologyName = DataString
WHERE DataType = 'Technology'
AND TST.IsActive = 1
AND UserID = @UserID 
;WITH CTE AS(
SELECT DISTINCT 
Id
FROM AdoptionFrameworkTechnologyCategory AFTC WITH (NOLOCK)
INNER JOIN #StackSubCategoryID 
ON AFTC.TechnologyCategoryId = StackSubCategoryID
WHERE IsActive =1)

UPDATE APPUSER SET CustomTechnologyPersonaID = (
SELECT 
STRING_AGG(Id,',')
FROM CTE) WHERE id = @UserID




-- CustomTeamPersonaID
;WITH CTE AS(SELECT DISTINCT
 AF.Id
FROM CustomUserData D
INNER JOIN AdoptionFramework AF
ON AF.Functionality = D.DataString
WHERE DataType = 'Team'
AND AF.IsActive = 1
AND D.UserID = @UserID
)

UPDATE AppUser SET CustomTeamPersonaID = (
SELECT 
STRING_AGG(ID,',')
FROM CTE)
WHERE ID = @UserID


-- CustomIntentPersonaID
;WITH CTE AS (SELECT DISTINCT
AF.Id
FROM CustomUserData D
INNER JOIN AdoptionFramework AF
ON AF.Functionality = D.DataString
WHERE DataType = 'Intent'
AND AF.IsActive = 1
AND D.UserID = @UserID
)
UPDATE AppUser SET CustomIntentPersonaID = (
SELECT DISTINCT 
STRING_AGG(ID,',')
FROM CTE) WHERE ID = @UserID


-- AppUser 
UPDATE APPUSER SET 
HasCustomPersona = 1 ,
CustomerType = 'Marketing',
PersonaIds = '',
CustomTeamPersonaID = @CustomTeamPersonaID,
CustomTechnologyPersonaID = @CustomTechnologyPersonaID,
CustomIntentPersonaID = @CustomIntentPersonaID
WHERE ID = @UserID

-- TargetPersona 
UPDATE TargetPersona SET CustomerType = 'Marketing'  , PersonaIDs = '',
RegionIDs	= A.RegionIds,
IndustryGroupIDs  = A.IndustryGroupIds
FROM TargetPersona T
INNER JOIN APPUSER A ON
A.ID = T.CREATEDBY
WHERE T.Id = @TargetPersonaID



-- Graphs
-- intent
INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,0
from UserDataContainer
WHERE UserID = @userid
AND DATATYPE = 'Intent'
GROUP BY DataString
ORDER BY 3 DESC

-- Technology
INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,0
from UserDataContainer
WHERE UserID = @userid
AND DATATYPE = 'Technology'
GROUP BY DataString
ORDER BY 3 DESC



-- Industry
;WITH CTE AS(
SELECT DISTINCT
O.ID,I.NAME
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
INNER JOIN INDUSTRY I ON I.ID = O.IndustryId
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Industry',NAME,COUNT(DISTINCT ID),@UserID,0
FROM CTE
GROUP BY NAME
ORDER BY 3 DESC


-- Revenue
;WITH CTE AS(
SELECT DISTINCT
O.ID,o.Revenue
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Revenue',Revenue,COUNT(DISTINCT ID),@UserID,0
FROM CTE
GROUP BY Revenue
ORDER BY 3 DESC



-- EmployeeCount
;WITH CTE AS(
SELECT DISTINCT
O.ID,o.EmployeeCount
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'EmployeeCount',EmployeeCount,COUNT(DISTINCT ID),@UserID,0
FROM CTE
GROUP BY EmployeeCount
ORDER BY 3 DESC



-- Country
;WITH CTE AS(
SELECT DISTINCT
O.ID,C.NAME
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
INNER JOIN CountrY C ON C.ID = O.COUNTRYID
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Country',NAME,COUNT(DISTINCT ID),@UserID,0
FROM CTE
GROUP BY NAME
ORDER BY 3 DESC


-- High Score
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,0
FROM UserDataContainer
WHERE USERID = @UserID


-- OtherProspect
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'OtherProspect',COUNT(OrganizationID),@UserID,0
FROM UserDataContainer
WHERE USERID = @UserID


--Insert UserDataOrganization(OrganizationID,OnboardedUser,UserID)
--SELECT DISTINCT
--OrganizationID ,0,@UserID
--FROM UserDataContainer
--WHERE USERID = @UserID
END
