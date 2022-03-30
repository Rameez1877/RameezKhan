/****** Object:  Procedure [dbo].[GetLatestPersonaData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetLatestPersonaData]  
AS BEGIN
SET NOCOUNT ON;

drop table [MASTER].[PersonaData]

CREATE TABLE [MASTER].[PersonaData](
	[OrganizationID] [int] NULL,
	[CountryID] [int] NULL,
	[RegionID] [int] NULL,
	[IndustryID] [int] NULL,
	[IndustryGroupID] [int] NULL,
	[TechTeamIntentID] [int] NULL,
	[PersonaID] [int] NULL
)



--- NORMAL 
INSERT INTO MASTER.PersonaData (OrganizationID,CountryID,RegionID,IndustryID,IndustryGroupID,TechTeamIntentID,PersonaID)
SELECT DISTINCT 
O.Id,C.ID,C.IsRegion,I.Id,I.IndustryGroupId,MO.TechnologyFunctionalityID,MP.PersonaID
FROM MASTER.OrganizationSummary MO 
INNER JOIN Organization O ON O.Id = MO.OrganizationID
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.Id = O.IndustryId
INNER JOIN MASTER.PersonaTechTeamIntent MP
ON MO.TechnologyFunctionalityID = MP.TechnologyFunctionalityID
WHERE MP.IsActive = 1
AND MP.PersonaID IN (SELECT DISTINCT ID FROM Persona WHERE IsActive = 1)
AND C.IsRegion IN (1,4,7,11)
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)


--- Staffing Needs 
INSERT INTO MASTER.PersonaData (OrganizationID,CountryID,RegionID,IndustryID,IndustryGroupID,TechTeamIntentID,PersonaID)
SELECT DISTINCT 
O.Id,C.ID,C.IsRegion,I.Id,I.IndustryGroupId,MO.TechnologyFunctionalityID,MP.PersonaID
FROM MASTER.OrganizationSummary MO 
INNER JOIN Organization O ON O.Id = MO.OrganizationID
INNER JOIN Country C ON C.ID = O.CountryId
INNER JOIN Industry I ON I.Id = O.IndustryId
INNER JOIN MASTER.PersonaTechTeamIntent MP
ON MO.TechnologyFunctionalityID = MP.TechnologyFunctionalityID
WHERE 
MP.PersonaID IN (SELECT DISTINCT ID FROM Persona WHERE Name= 'IT Outsourcing')
AND C.IsRegion IN (1,4,7,11)
AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)


CREATE INDEX [IX_OrganizationID] ON [MASTER].[PersonaData] (OrganizationID);

CREATE INDEX [IX_CountryID] ON [MASTER].[PersonaData] (CountryID);


CREATE INDEX [IX_RegionID] ON [MASTER].[PersonaData] (RegionID);


CREATE INDEX [IX_IndustryID] ON [MASTER].[PersonaData] (IndustryID);


CREATE INDEX [IX_IndustryGroupID] ON [MASTER].[PersonaData] (IndustryGroupID);


CREATE INDEX [IX_TechTeamIntentID] ON [MASTER].[PersonaData] (TechTeamIntentID);


CREATE INDEX [IX_PersonaID] ON [MASTER].[PersonaData] (PersonaID);



-----------------------------------------------------------------------------------------------------
exec QA_ResetUserConfiguration 123456789
DECLARE @PersonaIds VARCHAR(200), @RegionIds VARCHAR(200),  @IndustryGroupIds VARCHAR(200),@CustomerType  VARCHAR(200)


SELECT @PersonaIds = '59' ,@RegionIds = '1,4,7,11' ,@IndustryGroupIds = (SELECT STRING_AGG(ID,',') FROM IndustryGroup WHERE IsActive = 1)

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
SELECT DISTINCT
'HighScoring',COUNT(DISTINCT OrganizationID),123456789,1
FROM #HighScoring

INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
select DISTINCT TOP 4
'Intent',DataString,COUNT(DISTINCT OrganizationID),123456789,1
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
'Technology',DataString,COUNT(DISTINCT OrganizationID),123456789,1
FROM #Tech MP
INNER JOIN #MTech MT ON MP.TechTeamIntentID = MT.ID
GROUP BY DataString
ORDER BY 3 DESC



INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser) --2
SELECT DISTINCT 'Industry',Name,C,123456789,1 FROM #Indust




INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'Revenue',Revenue,C,123456789,1
FROM #REV






INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser)
SELECT DISTINCT TOP 4
'EmployeeCount',EmployeeCount,C,123456789,1
FROM #Emp






INSERT INTO [UserGraphContainer](GraphType,BarName,DataCount,UserID,OnboardedUser) --1
SELECT DISTINCT TOP 4
'Country',NAME,c,123456789,1
FROM #Countr



-- OtherProspect
INSERT INTO [UserGraphContainer](GraphType,DataCount,UserID,OnboardedUser)
SELECT  DISTINCT 
'OtherProspect',COUNT(OrganizationID),123456789,1
FROM #HighScoring


		
		SELECT DISTINCT Functionality INTO #Func FROM SurgeSummary WITH (NOLOCK)

		-- Intent
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'StaffingIntent','IT Outsourcing',S.Functionality,null,123456789
		FROM #Func S
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.Functionality
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN Persona P ON P.Id = MP.PersonaID
		WHERE MT.DataType = 'Intent'
		AND MP.IsActive = 1
		AND MP.PersonaID = 59
		ORDER BY 3,4

		-- Team
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'StaffingTeam','IT Outsourcing',S.TeamName,null,123456789
		FROM cache.OrganizationTeams S WITH (NOLOCK)
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.TeamName
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN Persona P ON P.Id = MP.PersonaID
		WHERE MT.DataType = 'Team'
		AND MP.IsActive = 1
		AND MP.PersonaID = 59
		ORDER BY 3,4

		
		-- Technology
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'StaffingTechnology',TSC.StackType ,S.Keyword,null,123456789
		FROM Technographics S WITH (NOLOCK)
		INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = S.Keyword
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.Keyword
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		WHERE MT.DataType = 'Technology'
		AND TST.IsActive = 1
		AND MP.IsActive = 1
		AND TSC.ISACTIVE = 1
		AND MP.PersonaID = 59
		ORDER BY 3,4


		-- EmployeeCount
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'StaffingEmployeeCount',NULL,EmployeeCount,COUNT(DISTINCT O.Id),123456789
		FROM Organization O
		INNER JOIN Country C ON O.CountryId = C.ID 
		INNER JOIN Industry I ON I.Id = O.IndustryId
		INNER JOIN MASTER.PersonaData MP ON MP.OrganizationID = O.Id
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		AND C.IsRegion IN (1,4,7,11)
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		AND MP.PersonaID = 59
		GROUP BY EmployeeCount
		ORDER BY 5 DESC


		-- Revenue
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'StaffingRevenue',NULL,Revenue,COUNT(DISTINCT O.Id),123456789
		FROM Organization O
		INNER JOIN Country C ON O.CountryId = C.ID 
		INNER JOIN Industry I ON I.Id = O.IndustryId
		INNER JOIN MASTER.PersonaData MP ON MP.OrganizationID = O.Id
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		AND C.IsRegion IN (1,4,7,11) AND MP.PersonaID = 59
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		GROUP BY Revenue
		ORDER BY 5 DESC

		
		--Country
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		C.ID,'StaffingCountry',NULL,C.Name ,COUNT(DISTINCT O.Id),123456789
		FROM Organization O 
		INNER JOIN Country C ON O.CountryId = C.ID
		INNER JOIN Industry I ON I.Id = O.IndustryId
		INNER JOIN MASTER.PersonaData MP ON MP.OrganizationID = O.Id
		WHERE C.IsRegion IN (1,4,7,11) AND MP.PersonaID = 59
		AND O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		GROUP BY C.ID,C.Name
		ORDER BY 5 DESC


		--Industry
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		I.ID,'StaffingIndustry',I.IndustryGroup,I.Name ,COUNT(DISTINCT O.Id),123456789
		FROM Organization O 
		INNER JOIN Industry I ON O.IndustryId = I.ID
		INNER JOIN Country C ON O.CountryId = C.ID
		INNER JOIN MASTER.PersonaData MP ON MP.OrganizationID = O.Id
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		AND  I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1) 
		AND C.IsRegion IN (1,4,7,11) AND MP.PersonaID = 59
		GROUP BY I.ID,I.Name,IndustryGroup
		ORDER BY 5 DESC

		

		-- GIC

		

		-- team
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'GicTeam',P.Name,S.TeamName,null,123456789
		FROM cache.OrganizationTeams S WITH (NOLOCK)
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.TeamName
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN Persona P ON P.Id = MP.PersonaID
		INNER JOIN GicOrganization G ON G.OrganizationID = S.OrganizationId
		WHERE MT.DataType = 'Team'
		AND P.IsActive = 1
		AND MP.IsActive = 1
		AND MP.PERSONAID <> 59
		ORDER BY 3,4

		
		-- Technology
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'GicTechnology',TSC.StackType ,S.Keyword,null,123456789
		FROM Technographics S WITH (NOLOCK)
		INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = S.Keyword
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.Keyword
		INNER JOIN MASTER.PERSONATECHTEAMINTENT MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN GicOrganization G ON G.OrganizationID = S.OrganizationId
		WHERE MT.DataType = 'Technology'
		AND TST.IsActive = 1
		AND MP.IsActive = 1
		AND TSC.ISACTIVE = 1
		AND MP.PERSONAID <> 59
		ORDER BY 3,4


		-- EmployeeCount
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'GicEmployeeCount',NULL,EmployeeCount,COUNT(DISTINCT G.OrganizationID),123456789
		FROM Organization O
		INNER JOIN GicOrganization G ON G.OrganizationID = O.Id
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		GROUP BY EmployeeCount
		ORDER BY 5 DESC


		-- Revenue
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'GicRevenue',NULL,Revenue,COUNT(DISTINCT G.OrganizationID),123456789
		FROM Organization O
		INNER JOIN GicOrganization G ON G.OrganizationID = O.Id
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		GROUP BY Revenue
		ORDER BY 5 DESC

		
	


		--Industry
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		I.ID,'GicIndustry',IG.Name,I.Name ,COUNT(DISTINCT G.OrganizationID),123456789
		FROM Organization O 
		INNER JOIN Industry I ON O.IndustryId = I.ID
		INNER JOIN IndustryGroup IG ON IG.Id = I.IndustryGroupId
		INNER JOIN GicOrganization G ON G.OrganizationID = O.Id
		WHERE IG.IsActive = 1
		AND O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		GROUP BY I.ID,I.Name,IG.Name
		ORDER BY 5 DESC

		-- GIC Countries 
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		G.CountryID,'GicCountry',NULL,C.Name,COUNT(G.OrganizationID),123456789
		FROM GicOrganization G
		INNER JOIN Organization O ON O.Id = G.OrganizationID
		INNER JOIN Country C ON C.ID = G.CountryID
		WHERE
		O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		GROUP BY G.CountryID,C.Name




		------ all

		
			-- ALL FILTER
		SELECT DISTINCT Functionality INTO #Func1 FROM SurgeSummary WITH (NOLOCK)

		-- Intent
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'Intent',p.Name,S.Functionality,null,123456789
		FROM #Func1 S
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.Functionality
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN Persona P ON P.Id = MP.PersonaID
		WHERE MT.DataType = 'Intent'
		AND MP.IsActive = 1
		AND MP.PersonaID <> 59
		ORDER BY 3,4

		-- Team
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'Team',P.Name,S.TeamName,null,123456789
		FROM cache.OrganizationTeams S WITH (NOLOCK)
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.TeamName
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		INNER JOIN Persona P ON P.Id = MP.PersonaID
		WHERE MT.DataType = 'Team'
		AND MP.IsActive = 1
		AND MP.PersonaID <> 59
		ORDER BY 3,4

		
		-- Technology
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		MT.ID,'Technology',TSC.StackType ,S.Keyword,null,123456789
		FROM Technographics S WITH (NOLOCK)
		INNER JOIN TechStackTechnology TST ON TST.StackTechnologyName = S.Keyword
		INNER JOIN TechStackSubCategory TSC ON TSC.ID = TST.StackSubCategoryId
		INNER JOIN MASTER.TechTeamIntent MT ON MT.DataString = S.Keyword
		INNER JOIN MASTER.PersonaTechTeamIntent MP ON MP.TechnologyFunctionalityID = MT.ID
		WHERE MT.DataType = 'Technology'
		AND TST.IsActive = 1
		AND MP.IsActive = 1
		AND TSC.ISACTIVE = 1
		AND MP.PersonaID <> 59
		ORDER BY 3,4


		-- EmployeeCount
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'EmployeeCount',NULL,EmployeeCount,COUNT(*),123456789
		FROM Organization O
		INNER JOIN Country C ON O.CountryId = C.ID 
		INNER JOIN Industry I ON I.Id = O.IndustryId
		WHERE IndustryId IS NOT NULL AND CountryId IS NOT NULL
		AND C.IsRegion IN (1,4,7,11)
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		GROUP BY EmployeeCount
		ORDER BY 5 DESC


		-- Revenue
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		0,'Revenue',NULL,Revenue,COUNT(*),123456789
		FROM Organization O
		INNER JOIN Country C ON O.CountryId = C.ID 
		INNER JOIN Industry I ON I.Id = O.IndustryId
		WHERE IndustryId IS NOT NULL AND CountryId IS NOT NULL
		AND C.IsRegion IN (1,4,7,11)
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		GROUP BY Revenue
		ORDER BY 5 DESC

		
		--Country
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		C.ID,'Country',NULL,C.Name ,COUNT(O.Id),123456789
		FROM Organization O 
		INNER JOIN Country C ON O.CountryId = C.ID
		INNER JOIN Industry I ON I.Id = O.IndustryId
		WHERE C.IsRegion IN (1,4,7,11)
		AND IndustryId IS NOT NULL AND CountryId IS NOT NULL
		AND I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1)
		GROUP BY C.ID,C.Name
		ORDER BY 5 DESC


		--Industry
		INSERT INTO UserFilters (ID,FilterType,Category,Data,DataString,UserID)
		SELECT DISTINCT
		I.ID,'Industry',I.IndustryGroup,I.Name ,COUNT(O.Id),123456789
		FROM Organization O 
		INNER JOIN Industry I ON O.IndustryId = I.ID
		INNER JOIN Country C ON O.CountryId = C.ID
		WHERE O.IndustryId IS NOT NULL AND O.CountryId IS NOT NULL
		AND  I.IndustryGroupId IN (SELECT ID FROM IndustryGroup WHERE IsActive = 1) 
		AND C.IsRegion IN (1,4,7,11)
		GROUP BY I.ID,I.Name,IndustryGroup
		ORDER BY 5 DESC

--------------------------------------------------------------------------------------------
END
