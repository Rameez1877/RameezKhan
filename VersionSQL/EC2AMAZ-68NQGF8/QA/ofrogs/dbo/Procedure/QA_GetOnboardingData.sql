/****** Object:  Procedure [dbo].[QA_GetOnboardingData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[QA_GetOnboardingData]  @UserId int
AS BEGIN
SET NOCOUNT ON;
	EXEC [QA_GetDashboardGraph] @UserId
	
--DECLARE 
--@CustomerType VARCHAR(200),
--@PersonaIds VARCHAR(200),
--@IndustryGroupIds VARCHAR(200),
--@RegionIds VARCHAR(200),
--@RunStaffing BIT,
--@RunMarketing BIT
	
--IF (EXISTS (SELECT TOP 1 * FROM [UserGraphContainer] WHERE UserID = @UserId))
--BEGIN
--  EXEC QA_ResetUserConfiguration @UserId
--END

--SELECT @CustomerType = CustomerType,
--@PersonaIds = PersonaIds,
--@IndustryGroupIds = IndustryGroupIds,
--@RegionIds = RegionIds
--FROM AppUser 
--WHERE  ID = @UserId

--SET @RunStaffing =  IIF (@CustomerType = 'staffing',1,0)
--SET @RunMarketing =  IIF (@CustomerType = 'marketing',1,0)

--IF
--@RunMarketing = 1
--BEGIN

----DROP TABLE IF EXISTS tempdb.dbo.##TmpFinal
--PRINT @CustomerType


--SELECT  TechnologyFunctionalityID into #TmpPersonaID  from MASTER.PersonaTechTeamIntent WHERE PersonaID IN ( SELECT VALUE FROM string_split(@PersonaIds,',')) AND IsActive = 1
--SELECT ID into  #TmpCountryID  from Country where IsRegion in ( select value from string_split(@RegionIds,','))
--SELECT ID into  #TmpGroupID  from Industry where IndustryGroupId in ( select value from string_split(@IndustryGroupIds,','))



--SELECT DISTINCT  
--o.Id INTO #TmpOrg
--FROM 
-- Organization O 
--INNER JOIN #TmpCountryID C ON C.ID = O.CountryId
--INNER JOIN #TmpGroupID I ON I.Id= O.IndustryId


--SELECT DISTINCT  
--mo.OrganizationID,MO.TechnologyFunctionalityID TypeID INTO #TmpFinal
--FROM #TmpPersonaID MP
--INNER JOIN MASTER.OrganizationSummary MO ON MO.TechnologyFunctionalityID = MP.TechnologyFunctionalityID
--INNER JOIN #TmpOrg T ON MO.OrganizationID = T.Id


--INSERT into DashboardUserData
--select OrganizationID,TypeID,@UserID from #TmpFinal

---- High Score
--INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
--SELECT 
--'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
--FROM #TmpFinal T



--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from #TmpFinal T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE MT.DataType = 'Intent' AND MT.IsActive = 1 
--GROUP BY DataString
--ORDER BY 3 DESC

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from #TmpFinal T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE  DATATYPE = 'Technology'
--AND MT.IsActive = 1 
--GROUP BY DataString
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,I.NAME
--FROM #TmpFinal D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN INDUSTRY I ON I.ID = O.IndustryId
-- )


--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Industry',NAME,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY NAME
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.Revenue
--FROM #TmpFinal D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID )

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Revenue',Revenue,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY Revenue
--ORDER BY 3 DESC



--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.EmployeeCount
--FROM #TmpFinal D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID )

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
--FROM #TmpFinal D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN CountrY C ON C.ID = O.COUNTRYID  )

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
--FROM #TmpFinal 
--END
	
--ELSE IF @RunStaffing = 1
--BEGIN

--PRINT @CustomerType

--UPDATE AppUser SET PersonaIds = '59'
--,RegionIds = '1,4,7,11'
--,IndustryGroupIds = '1,2,3,4,5,6,7,8,9,10,11,12,14,15,17,18,19,20' WHERE Id = @UserId

--SELECT OrganizationID,TypeID into #TmpFuss FROM DashboardUserData WHERE UserID = 123456789


--INSERT INTO DashboardUserData
--SELECT OrganizationID,TypeID,@UserId FROM #TmpFuss

---- High Score
--INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
--SELECT 
--'HighScoring',COUNT(DISTINCT OrganizationID),@UserID,1
--FROM #TmpFuss T



--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Intent',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from #TmpFuss T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE MT.DataType = 'Intent' AND MT.IsActive = 1 
--GROUP BY DataString
--ORDER BY 3 DESC

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--select DISTINCT TOP 4
--'Technology',DataString,COUNT(DISTINCT OrganizationID),@UserID,1
--from #TmpFuss T
--INNER JOIN MASTER.TechTeamIntent MT ON T.TypeID = MT.ID
--WHERE  DATATYPE = 'Technology'
--AND MT.IsActive = 1 
--GROUP BY DataString
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,I.NAME
--FROM #TmpFuss D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN INDUSTRY I ON I.ID = O.IndustryId
-- )


--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Industry',NAME,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY NAME
--ORDER BY 3 DESC

--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.Revenue
--FROM #TmpFuss D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID )

--INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
--SELECT DISTINCT TOP 4
--'Revenue',Revenue,COUNT(DISTINCT ID),@UserID,1
--FROM CTE
--GROUP BY Revenue
--ORDER BY 3 DESC



--;WITH CTE AS(
--SELECT DISTINCT
--O.ID,o.EmployeeCount
--FROM #TmpFuss D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID )

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
--FROM #TmpFuss D
--INNER JOIN Organization O 
--ON O.Id = D.ORGANIZATIONID
--INNER JOIN CountrY C ON C.ID = O.COUNTRYID  )

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
--FROM #TmpFuss 

--END
PRINT 'Onboarding Gone'

END
