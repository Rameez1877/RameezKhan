/****** Object:  Procedure [dbo].[GetGICDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

-- 26-NOV-2021 - KABIR - SP should run when new GIC organizations come in GicOrganization[table].
CREATE PROCEDURE [dbo].[GetGICDashboardData]

AS 
BEGIN

SET NOCOUNT ON;


INSERT INTO GICDashboardOrganization(OrganizationID,Revenue,EmployeeCount,HeadquarterID,
GIC_CountryID,IndustryId) 
SELECT distinct G.OrganizationID ,
O.Revenue,O.EmployeeCount,O.CountryId HeadquarterID,
G.CountryID GIC_CountryID,o.IndustryId
FROM GicOrganization G
LEFT JOIN ORGANIZATION O ON O.ID = G.OrganizationID
WHERE G.OrganizationID NOT IN (SELECT DISTINCT OrganizationID FROM GICDashboardOrganization)

INSERT INTO GICDashboardTeams (OrganizationID,TeamName)
SELECT distinct G.OrganizationID,T.TEAMNAME
FROM GicOrganization G
LEFT JOIN cache.OrganizationTeams T ON G.ORGANIZATIONID = T.ORGANIZATIONID 
WHERE G.OrganizationID NOT IN (SELECT DISTINCT OrganizationID FROM GICDashboardTeams)

INSERT INTO GICDashboardTechnology (OrganizationID,Technology)
SELECT DISTINCT G.OrganizationID,T.Keyword AS Technology
FROM GicOrganization G
LEFT JOIN TECHNOGRAPHICS T ON G.ORGANIZATIONID = T.ORGANIZATIONID 
WHERE G.OrganizationID NOT IN (SELECT DISTINCT OrganizationID FROM GICDashboardTechnology)


END
