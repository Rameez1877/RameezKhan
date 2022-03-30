/****** Object:  Procedure [dbo].[PopulateWebsiteGraphData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE PopulateWebsiteGraphData
AS
BEGIN

DECLARE @OrganizationId INT
DECLARE PopulateGraphData CURSOR FOR SELECT  OrganizationId FROM dbo.WebsiteOrganizations 

OPEN PopulateGraphData

FETCH NEXT FROM PopulateGraphData INTO @OrganizationId

WHILE @@FETCH_STATUS = 0
BEGIN

	INSERT INTO dbo.WebsiteGraphData(OrganizationId,GraphType,Name,Value)

	SELECT TOP 4 @OrganizationId, 'InvestmentsPerDuration', s.Duration,COUNT(InvestmentType) [Values] FROM dbo.WebsiteOrganizationIntents s WITH (NOLOCK)
	where  s.OrganizationId = @OrganizationId GROUP BY s.Duration ORDER BY [Values] DESC
    
	INSERT INTO dbo.WebsiteGraphData(OrganizationId,GraphType,Name,Value)

	SELECT TOP 4 @OrganizationId,'InvestmentTypesPerCategory', s.Category,COUNT(InvestmentType) [Values] FROM WebsiteOrganizationIntents s WITH (NOLOCK)
	where   s.OrganizationId = @OrganizationId GROUP BY s.Category ORDER by [Values]  DESC
    
	INSERT INTO dbo.WebsiteGraphData(OrganizationId,GraphType,Name,Value)

	SELECT TOP 4 @OrganizationId, 'DecisionmakerPerFunctionality',c.Functionality ,COUNT(DISTINCT c.DecisionMakerId) AS [Values] FROM 
	dbo.WebsiteOrganizationContacts c INNER JOIN dbo.LinkedInData l ON l.id = c.DecisionMakerId
	WHERE L.SeniorityLevel IN ('C-Level', 'Director', 'Influencer') and l.OrganizationId = @OrganizationId
	GROUP BY c.Functionality ORDER BY [Values] DESC

	INSERT INTO dbo.WebsiteGraphData(OrganizationId,GraphType,Name,Value)

	SELECT TOP 4 @OrganizationId, 'EmployeePerFuncationality' AS GraphType, c.Functionality,COUNT(DISTINCT c.DecisionMakerId) AS [Values] 
	FROM  dbo.WebsiteOrganizationContacts c 
	WHERE OrganizationId = @OrganizationId
	GROUP BY c.Functionality ORDER BY [Values] DESC

	INSERT INTO dbo.WebsiteGraphData(OrganizationId,GraphType,Name,Value)

	SELECT	TOP 4 @OrganizationId,'TechnologiesPerCategory',tech.Category,COUNT(DISTINCT Tech.Technology) AS [Values] FROM dbo.WebsiteOrgTechnologies tech
	WHERE Tech.OrganizationId = @OrganizationId
	GROUP BY tech.Category ORDER BY [Values] DESC

FETCH NEXT FROM PopulateGraphData INTO @OrganizationId
END
CLOSE PopulateGraphData
DEALLOCATE PopulateGraphData
END
