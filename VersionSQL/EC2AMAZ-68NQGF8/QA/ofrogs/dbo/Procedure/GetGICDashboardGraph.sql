/****** Object:  Procedure [dbo].[GetGICDashboardGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- 26-NOV-2021 - KABIR -- SP will populate graph for GIC Dashabord.
-- EXEC [GetGICDashboardGraph]
CREATE PROCEDURE [dbo].[GetGICDashboardGraph] 

AS 
BEGIN

SET NOCOUNT ON;
DECLARE @NONGIC INT = (SELECT COUNT(DISTINCT ID) FROM Organization)
SELECT COUNT(DISTINCT OrganizationID) GicAccounts, @NONGIC NonGicAccounts
FROM GICDashboardOrganization

SELECT TOP 4 COUNT(DISTINCT OrganizationID) AS VALUE ,C.Name AS NAME 
FROM GICDashboardOrganization G
INNER JOIN Country C ON C.ID = G.HeadquarterID
GROUP BY C.Name
ORDER BY 1 DESC

SELECT TOP 4 COUNT(DISTINCT OrganizationID)  AS VALUE ,EmployeeCount AS NAME 
FROM GICDashboardOrganization G
GROUP BY EmployeeCount
ORDER BY 1 DESC

SELECT TOP 4 COUNT(DISTINCT OrganizationID)  AS VALUE ,Revenue AS NAME 
FROM GICDashboardOrganization G
GROUP BY Revenue
ORDER BY 1 DESC

SELECT TOP 4 COUNT(DISTINCT OrganizationID)  AS VALUE ,C.Name AS NAME 
FROM GICDashboardOrganization G
INNER JOIN Country C ON C.ID = G.GIC_CountryID
GROUP BY C.Name
ORDER BY 1 DESC

SELECT TOP 4 COUNT(DISTINCT OrganizationID)  AS VALUE ,TeamName AS NAME 
FROM GICDashboardTeams
GROUP BY TeamName
ORDER BY 1 DESC

SELECT TOP 4 COUNT(DISTINCT OrganizationID)  AS VALUE ,Technology AS NAME 
FROM GICDashboardTechnology
GROUP BY Technology
ORDER BY 1 DESC

SELECT TOP 4 COUNT(i.id)  AS VALUE ,i.Name AS NAME 
FROM GICDashboardOrganization g 
inner join industry i on (i.id=g.IndustryId)
GROUP BY i.Name
ORDER BY 1 DESC

END
