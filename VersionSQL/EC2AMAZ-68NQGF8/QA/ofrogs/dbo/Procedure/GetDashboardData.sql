/****** Object:  Procedure [dbo].[GetDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

--  18-Nov-21 - Kabir
-- EXEC [QA_GetDashboardData] 159
CREATE PROCEDURE [dbo].[GetDashboardData] @UserId int
AS BEGIN
SET NOCOUNT ON;
	
	
	
	DECLARE 
	@CustomerType VARCHAR(200),
	@PersonaIds VARCHAR(200),
	@IndustryGroupIds VARCHAR(200),
	@RegionIds VARCHAR(200),
	@TechnologyPersona BIT 
	

SELECT @CustomerType = CustomerType,
@PersonaIds = PersonaIds,
@IndustryGroupIds = IndustryGroupIds,
@RegionIds = RegionIds
FROM AppUser 
WHERE  ID = @UserID

SELECT DISTINCT
Category,Functionality INTO #TmpAF
FROM ADOPTIONFRAMEWORK A
INNER JOIN Persona P ON A.Category = P.Name
WHERE P.Id IN (SELECT VALUE FROM string_split(@PersonaIds,','))
AND P.IsActive = 1
AND A.IsActive = 1

	SELECT DISTINCT
NAME INTO #TmpName
FROM McDecisionmaker
WHERE IsActive = 1
AND IsOFList = 1

SELECT DISTINCT
ID,IsRegion INTO #TmpCo
FROM Country
WHERE IsRegion IN (SELECT VALUE FROM string_split(@RegionIds,','))


SELECT DISTINCT
ID,IndustryGroupId INTO #TmpInd
FROM Industry
WHERE IndustryGroupId IN (SELECT VALUE FROM string_split(@IndustryGroupIds,','))

SELECT DISTINCT
t.Technology INTO #TmpTech
FROM Persona p
INNER JOIN AdoptionFrameworkTechnologyCategory A  ON P.Name = A.Category
INNER JOIN Technologies T ON T.SubCategoryID = A.TechnologyCategoryId
where T.IsActive = 1 AND 
P.Id IN (SELECT VALUE FROM string_split(@PersonaIds,','))


delete from UserDataContainer where userid = @UserID
delete from [UserGraphContainer] where userid = @UserID

select  value INTO #TmpPersonaID from string_split(@PersonaIds,',')

SET @TechnologyPersona = IIF(EXISTS(
SELECT T.value
FROM #TmpPersonaID T
INNER JOIN Persona P
ON P.ID = T.value
WHERE T.value IN (SELECT ID FROM Persona WHERE IsTechnology = 1)),1,0)

IF @TechnologyPersona = 0 
BEGIN
INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Intent' AS DataType,
O.Id OrganizationID,
S.Functionality DataString,
@UserID AS UserID ,1 
FROM  #TmpAF A  
INNER JOIN #TmpName M  ON M.NAME = A.FUNCTIONALITY
INNER JOIN SURGESUMMARY S WITH(NOLOCK) ON S.FUNCTIONALITY = M.NAME
INNER JOIN ORGANIZATION O WITH(NOLOCK) ON O.ID = S.ORGANIZATIONID
INNER JOIN #TmpCo C  ON C.ID = O.CountryId
INNER JOIN #TmpInd I  ON I.Id = O.IndustryId

INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Technology',O.Id,T.Keyword,@UserID,1
FROM #TmpTech TST
INNER JOIN Technographics T WITH(NOLOCK) ON T.Keyword = TST.Technology
INNER JOIN Organization O WITH(NOLOCK) ON O.Id = T.OrganizationId
INNER JOIN #TmpCo C ON C.ID = O.CountryId
INNER JOIN #TmpInd I ON I.Id = O.IndustryId
 


INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Team',O.Id,OT.TeamName,@UserID,1
FROM #TmpAF a
INNER JOIN cache.OrganizationTeams OT WITH(NOLOCK) ON OT.TeamName = A.Functionality
INNER JOIN #TmpName M  ON M.Name = A.Functionality
INNER JOIN Organization O  ON O.Id = OT.OrganizationId
INNER JOIN #TmpCo C ON C.ID = O.CountryId
INNER JOIN #TmpInd I ON I.Id = O.IndustryId


-- High Score
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
FROM UserDataContainer
WHERE USERID = @UserID
END
	

ELSE IF @TechnologyPersona = 1
BEGIN

INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Technology',O.Id,T.Keyword,@UserID,1
FROM #TmpTech TST
INNER JOIN Technographics T WITH(NOLOCK) ON T.Keyword = TST.Technology
INNER JOIN Organization O WITH(NOLOCK) ON O.Id = T.OrganizationId
INNER JOIN #TmpCo C ON C.ID = O.CountryId
INNER JOIN #TmpInd I ON I.Id = O.IndustryId

INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Intent' AS DataType,
O.Id OrganizationID,
S.Functionality DataString,
@UserID AS UserID ,1 
FROM  #TmpAF A  
INNER JOIN #TmpName M  ON M.NAME = A.FUNCTIONALITY
INNER JOIN SURGESUMMARY S WITH(NOLOCK) ON S.FUNCTIONALITY = M.NAME
INNER JOIN ORGANIZATION O WITH(NOLOCK) ON O.ID = S.ORGANIZATIONID
INNER JOIN #TmpCo C  ON C.ID = O.CountryId
INNER JOIN #TmpInd I  ON I.Id = O.IndustryId
INNER JOIN UserDataContainer U ON U.OrganizationID = O.Id
WHERE U.UserID = @UserId

INSERT INTO UserDataContainer (DataType,OrganizationID,DataString,UserID,OnboardedUser)
SELECT DISTINCT 
'Team',O.Id,OT.TeamName,@UserID,1
FROM #TmpAF a
INNER JOIN cache.OrganizationTeams OT WITH(NOLOCK) ON OT.TeamName = A.Functionality
INNER JOIN #TmpName M  ON M.Name = A.Functionality
INNER JOIN Organization O  ON O.Id = OT.OrganizationId
INNER JOIN #TmpCo C ON C.ID = O.CountryId
INNER JOIN #TmpInd I ON I.Id = O.IndustryId
INNER JOIN UserDataContainer U ON U.OrganizationID = O.Id
WHERE U.UserID = @UserId

-- High Score
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
FROM UserDataContainer
WHERE USERID = @UserID
AND DataType = 'Technology'
END


INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
from UserDataContainer
WHERE UserID = @userid
AND DATATYPE = 'Intent'
GROUP BY DataString
ORDER BY 3 DESC

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
from UserDataContainer
WHERE UserID = @userid
AND DATATYPE = 'Technology'
GROUP BY DataString
ORDER BY 3 DESC

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
'Industry',NAME,COUNT(DISTINCT ID),@UserID,1
FROM CTE
GROUP BY NAME
ORDER BY 3 DESC

;WITH CTE AS(
SELECT DISTINCT
O.ID,o.Revenue
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Revenue',Revenue,COUNT(DISTINCT ID),@UserID,1
FROM CTE
GROUP BY Revenue
ORDER BY 3 DESC



;WITH CTE AS(
SELECT DISTINCT
O.ID,o.EmployeeCount
FROM UserDataContainer D
INNER JOIN Organization O 
ON O.Id = D.ORGANIZATIONID
WHERE USERID = @userid)

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'EmployeeCount',EmployeeCount,COUNT(DISTINCT ID),@UserID,1
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
'Country',NAME,COUNT(DISTINCT ID),@UserID,1
FROM CTE
GROUP BY NAME
ORDER BY 3 DESC


-- OtherProspect
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'OtherProspect',COUNT(OrganizationID),@UserID,1
FROM UserDataContainer
WHERE USERID = @UserID



-- AppUser 
UPDATE APPUSER SET 
HasCustomPersona = 0 
WHERE ID = @UserID

END
