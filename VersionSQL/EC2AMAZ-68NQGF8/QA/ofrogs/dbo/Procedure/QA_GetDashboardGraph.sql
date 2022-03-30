/****** Object:  Procedure [dbo].[QA_GetDashboardGraph]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[QA_GetDashboardGraph] @UserId int
AS BEGIN
SET NOCOUNT ON;
	

DECLARE @PersonaIds VARCHAR(200), @RegionIds VARCHAR(200),  @IndustryGroupIds VARCHAR(200),@CustomerType  VARCHAR(200),@Count INT




SELECT @PersonaIds = PersonaIds,@RegionIds = RegionIds,@IndustryGroupIds = IndustryGroupIds, @CustomerType = CustomerType FROM AppUser WHERE Id = @UserID

set @Count = (SELECT COUNT(*) FROM UserGraphContainer WHERE UserID = @UserId)

 IF @CustomerType = 'staffing' AND @Count = 0 BEGIN
 UPDATE AppUser SET PersonaIds= '59',RegionIds = '1,4,7,11' ,IndustryGroupIds = (SELECT STRING_AGG(ID,',') FROM IndustryGroup WHERE IsActive = 1) WHERE ID = @UserId
 DELETE FROM UserGraphContainer WHERE UserID = @UserId
 INSERT INTO UserGraphContainer (ID,GraphType,BarName,DataCount,OnboardedUser,UserID)
 SELECT DISTINCT ID,GraphType,BarName,DataCount,OnboardedUser,@UserId FROM UserGraphContainer WHERE UserID = 123456789
 END

	
DECLARE @CustomPersona BIT, @Run BIT, @IsNewUser BIT

	SET @Run = IIF(EXISTS(SELECT TOP 1 * FROM [UserGraphContainer] WHERE UserID = @UserId),0,1)
		SET @IsNewUser = IIF((SELECT IsNewUser FROM APPUSER WHERE ID = @UserID) =1 ,1,0)

		IF @Run = 1 AND @IsNewUser = 1
		BEGIN
		select u1.DataCount as HighScoringAccount, u2.DataCount as OtherProspect
	from UserGraphContainer u1
	inner join UserGraphContainer u2 on (u1.UserID = u2.UserID)
	where u1.userid = 0
	AND u1.GraphType = 'HighScoring'
	AND u2.GraphType = 'OtherProspect'


	--Country
	select DISTINCT
	C.ID,BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer U
	INNER JOIN Country C ON C.Name = U.BarName
	where userid = 0
	AND GraphType = 'Country'
	ORDER BY 3 DESC

	--Industry
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =0
	AND GraphType = 'Industry'
	
	-- Technology
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =0
	AND GraphType = 'Technology'

	-- Revenue
	select BarName AS [Name] , DataCount AS [Value] 
	from UserGraphContainer
	where userid =0
	AND GraphType = 'Revenue'

	-- EmployeeCount
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =0
	AND GraphType = 'EmployeeCount'

	--Intent
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =0
	AND GraphType = 'Intent'
		END
	IF @Run = 1 AND @IsNewUser = 0 BEGIN
	print 'insert'
SELECT 
@PersonaIds = PersonaIds,
@CustomPersona = HasCustomPersona
FROM AppUser 
WHERE  ID = @UserID

SELECT VALUE id INTO #TmpPersonaID FROM string_split(@PersonaIds,',')




IF  @CustomPersona = 0
BEGIN



SELECT @PersonaIds = PersonaIds,@RegionIds = RegionIds,@IndustryGroupIds = IndustryGroupIds FROM AppUser WHERE Id = @UserId

SELECT VALUE INTO #PersonaIds FROM string_split(@PersonaIds,',')
SELECT VALUE INTO #RegionIds FROM string_split(@RegionIds,',')
SELECT VALUE INTO #IndustryGroupIds FROM string_split(@IndustryGroupIds,',')


	
SELECT  MP.OrganizationID
INTO #HighScoring
FROM MASTER.PersonaData MP
INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
INNER JOIN #RegionIds R ON R.value = MP.RegionID
INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID


SELECT MP.OrganizationID,MP.TechTeamIntentID INTO #Tech 
FROM MASTER.PersonaData MP
INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
INNER JOIN #RegionIds R ON R.value = MP.RegionID
INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID

SELECT ID,DataString INTO #MTech FROM MASTER.TechTeamIntent WHERE DataType = 'Technology' and IsActive = 1




;WITH CTE AS (
SELECT TOP 4 COUNT(DISTINCT MP.OrganizationID) C,MP.IndustryID
FROM MASTER.PersonaData MP
INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
INNER JOIN #RegionIds R ON R.value = MP.RegionID
INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
GROUP BY IndustryID 
ORDER BY 1 DESC
)
SELECT DISTINCT I.Name,C.C INTO #Indust  FROM CTE C INNER JOIN Industry I ON I.Id = C.IndustryID



SELECT TOP 4 COUNT(DISTINCT H.OrganizationID) C,O.Revenue INTO #REV
FROM #HighScoring H
INNER JOIN Organization O ON H.OrganizationID = O.Id
GROUP BY Revenue
ORDER BY 1 DESC


SELECT TOP 4 COUNT(DISTINCT H.OrganizationID) C,O.EmployeeCount INTO #Emp
FROM #HighScoring H
INNER JOIN Organization O ON H.OrganizationID = O.Id
GROUP BY EmployeeCount
ORDER BY 1 DESC




;WITH CTE AS (
SELECT TOP 4 COUNT(DISTINCT MP.OrganizationID) C,MP.CountryID
FROM MASTER.PersonaData MP
INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
INNER JOIN #RegionIds R ON R.value = MP.RegionID
INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
GROUP BY CountryID 
ORDER BY 1 DESC
)
SELECT DISTINCT I.Name,C.C INTO #Countr  FROM CTE C INNER JOIN Country I ON I.Id = C.CountryID












--------------------------------------
-- High Score
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
FROM #HighScoring

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
FROM MASTER.PersonaData MP
INNER JOIN #PersonaIds P ON P.value = MP.PersonaID
INNER JOIN #RegionIds R ON R.value = MP.RegionID
INNER JOIN #IndustryGroupIds I ON I.value = MP.IndustryGroupID
INNER JOIN MASTER.TechTeamIntent MT ON MP.TechTeamIntentID = MT.ID
WHERE MT.DataType = 'Intent' AND MT.IsActive = 1 
GROUP BY DataString
ORDER BY 3 DESC

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser) --1
select DISTINCT TOP 4
'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
FROM #Tech MP
INNER JOIN #MTech MT ON MP.TechTeamIntentID = MT.ID
GROUP BY DataString
ORDER BY 3 DESC



INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser) --2
SELECT 'Industry',Name,C,@UserID,1 FROM #Indust




INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Revenue',Revenue,C,@UserID,1
FROM #REV






INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'EmployeeCount',EmployeeCount,C,@UserID,1
FROM #Emp






INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser) --1
SELECT DISTINCT TOP 4
'Country',NAME,c,@UserID,1
FROM #Countr



-- OtherProspect
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT 
'OtherProspect',COUNT(OrganizationID),@UserID,1
FROM #HighScoring


EXEC QA_GetDashboardGraph @UserID --23 -- 31


END

IF @CustomPersona = 1 
BEGIN

----------------------------------------
---- High Score
--INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
--SELECT 
--'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
--FROM DashboardUserData T
--WHERE UserID = @UserId


--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from DashboardUserData T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE MT.DataType = 'Intent' AND MT.IsActive = 1 AND UserID = @UserId
--GROUP BY DataString
--ORDER BY 3 DESC

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from DashboardUserData T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE  DATATYPE = 'Technology'
--AND MT.IsActive = 1 AND UserID = @UserId
--GROUP BY DataString
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,I.NAME
--FROM DashboardUserData D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN INDUSTRY I ON I.ID = O.IndustryId
--WHERE UserID = @UserId )


--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Industry',NAME,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY NAME
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.Revenue
--FROM DashboardUserData D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID WHERE UserID = @UserId )

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Revenue',Revenue,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY Revenue
--ORDER BY 3 DESC



--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.EmployeeCount
--FROM DashboardUserData D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID WHERE UserID = @UserId )

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'EmployeeCount',EmployeeCount,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY EmployeeCount
--ORDER BY 3 DESC



---- Country
--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,C.NAME
--FROM DashboardUserData D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN CountrY C ON C.ID = O.COUNTRYID WHERE UserID = @UserId )

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Country',NAME,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY NAME
--ORDER BY 3 DESC


---- OtherProspect
--INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
--SELECT 
--'OtherProspect',COUNT(OrganizationID),@UserID,1
--FROM DashboardUserData WHERE UserID = @UserId
--EXEC QA_GetDashboardGraph @UserID
print 'This feature is not in use'


END

--exec [QA_GetDashboardGraph] @USERID
END

ELSE IF @Run = 0 AND @IsNewUser = 0
BEGIN
print 'show'
select MAX(u1.DataCount) as HighScoringAccount, MAX(u2.DataCount) as OtherProspect
	from UserGraphContainer u1
	inner join UserGraphContainer u2 on (u1.UserID = u2.UserID)
	where u1.userid = @UserID
	AND u1.GraphType = 'HighScoring'
	AND u2.GraphType = 'OtherProspect'


	--Country
	select DISTINCT
	C.ID,BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer U
	INNER JOIN Country C ON C.Name = U.BarName
	where userid = @UserId
	AND GraphType = 'Country'
	ORDER BY 3 DESC

	--Industry
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =@userid
	AND GraphType = 'Industry'
	ORDER BY 2 DESC

	-- Technology
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =@userid
	AND GraphType = 'Technology'
	ORDER BY 2 DESC

	-- Revenue
	select BarName AS [Name] , DataCount AS [Value] 
	from UserGraphContainer
	where userid =@userid
	AND GraphType = 'Revenue'
	ORDER BY 2 DESC

	-- EmployeeCount
	select BarName AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid =@userid
	AND GraphType = 'EmployeeCount'
	ORDER BY 2 DESC

	--Intent
	select case BarName when  'Human Resource' then 'Human Resources'
	else BarName end AS [Name] , DataCount AS [Value]
	from UserGraphContainer
	where userid = @UserId
	AND GraphType = 'Intent'
	ORDER BY 2 DESC

END
END
