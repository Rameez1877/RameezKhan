/****** Object:  Procedure [dbo].[GetGicTest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE GetGicTest
AS
BEGIN

  SET NOCOUNT ON;

	  SELECT
		COUNT(DISTINCT OrganizationId) AS HighScoringAccount,
		COUNT(organizationId) AS TotalAccounts
	  FROM GicOrganization

	  SELECT TOP 4
		c.[Name] AS [Name],
		COUNT(1) AS [Value]
	  FROM GicOrganization g
	  INNER JOIN Country c
		ON (g.CountryID = c.ID)
	  GROUP BY Name
	  ORDER BY 2 DESC

	  SELECT TOP 4
		o.Revenue AS [Name],
		COUNT(1) AS [Value]
	  FROM GicOrganization g
	  INNER JOIN Organization O
		ON (o.Id = g.OrganizationID)
	  GROUP BY o.Revenue
	  ORDER BY 2 DESC

	  SELECT TOP 4
		o.EmployeeCount AS [Name],
		COUNT(1) AS [Value]
	  FROM GicOrganization g
	  INNER JOIN Organization O
		ON (o.Id = g.OrganizationID)
	  GROUP BY o.EmployeeCount
	  ORDER BY 2 DESC

	  SELECT TOP 4
		i.[Name],
		COUNT(1) AS [Value]
	  FROM GicOrganization g
	  INNER JOIN Organization O
		ON (o.Id = g.OrganizationID)
	  INNER JOIN Industry i
		ON (i.Id = o.IndustryId)
	  GROUP BY i.[Name]
	  ORDER BY 2 DESC

	   SELECT TOP 4
		o.TeamName as [Name],
		COUNT(distinct g.OrganizationID) AS [Value]
	  FROM GicOrganization g
	  INNER JOIN cache.OrganizationTeams O
		ON (o.Id = g.OrganizationID)
	  GROUP BY o.TeamName
	  ORDER BY 2 DESC

END
