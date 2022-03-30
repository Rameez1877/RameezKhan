/****** Object:  Procedure [dbo].[DeleteWebsiteGraphData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE DeleteWebsiteGraphData
AS
BEGIN

DECLARE @OrganizationId INT
DECLARE PopulateGraphData CURSOR FOR SELECT  OrganizationId FROM dbo.WebsiteOrganizations 

OPEN PopulateGraphData

FETCH NEXT FROM PopulateGraphData INTO @OrganizationId

WHILE @@FETCH_STATUS = 0
BEGIN

DELETE FROM dbo.WebsiteOrganizationContacts WHERE DecisionMakerId not IN (SELECT  TOP 20 DecisionMakerId FROM  dbo.WebsiteOrganizationContacts WHERE OrganizationId = @OrganizationId)
AND OrganizationId = @OrganizationId

DELETE FROM dbo.WebsiteOrganizationIntents WHERE id not IN (SELECT  TOP 20 id FROM  dbo.WebsiteOrganizationContacts WHERE OrganizationId = @OrganizationId)
AND OrganizationId = @OrganizationId

DELETE FROM dbo.WebsiteOrgTechnologies WHERE ID NOT IN (SELECT TOP 20 ID  FROM  dbo.WebsiteOrgTechnologies WHERE OrganizationId = @OrganizationId)

FETCH NEXT FROM PopulateGraphData INTO @OrganizationId
END
CLOSE PopulateGraphData
DEALLOCATE PopulateGraphData
END
