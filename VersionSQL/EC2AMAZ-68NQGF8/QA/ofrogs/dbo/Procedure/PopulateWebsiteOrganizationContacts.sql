/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationContacts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE PopulateWebsiteOrganizationContacts

AS
BEGIN
   


INSERT INTO dbo.WebsiteOrganizationContacts
(
    DecisionMakerId,
    OrganizationId,
    FirstName,
    LastName,
    Designation,
    Location,
    Url
)


SELECT DISTINCT
		L.Id,
		L.OrganizationId,
		L.FirstName,
		L.LastName,
		L.ModifiedDesignation,
		L.country,
		L.url
	FROM 
		LinkedInData L WITH (NOLOCK)

		inner join Organization O WITH (NOLOCK) on (O.Id = L.OrganizationId)
		INNER JOIN dbo.McDecisionmakerlist ON McDecisionmakerlist.DecisionMakerId = L.id
	WHERE 
		OrganizationId IN (SELECT OrganizationId FROM  dbo.WebsiteOrganizations)


UPDATE dbo.WebsiteOrganizationContacts SET Team = TeamName FRom  cache.OrganizationTeams WHERE 
OrganizationTeams.OrganizationId =WebsiteOrganizationContacts.OrganizationId

UPDATE dbo.WebsiteOrganizationContacts SET Functionality = Functionality FRom  dbo.McDecisionmakerlist m WHERE 
m.DecisionMakerId = dbo.WebsiteOrganizationContacts.DecisionMakerId

END;
