/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationRelatedData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE PopulateWebsiteOrganizationRelatedData

AS
BEGIN
--CompanyTechnology

INSERT INTO dbo.WebsiteOrgTechnologies(OrganizationId,Technology)
	
SELECT DISTINCT Tech.OrganizationId,Tech.Keyword FROM Technographics Tech WITH (NOLOCK),TechStackTechnology tst,TechStackSubCategory tssc
WHERE Tech.Keyword = tst.StackTechnologyName AND tst.StackSubCategoryId = tssc.ID AND Tech.OrganizationId IN (SELECT OrganizationId FROM  dbo.WebsiteOrganizations)

UPDATE dbo.WebsiteOrgTechnologies SET Category =  tssc.StackType FROM Technographics Tech WITH (NOLOCK),TechStackTechnology tst,TechStackSubCategory tssc
WHERE Tech.Keyword = tst.StackTechnologyName AND tst.StackSubCategoryId = tssc.ID AND Tech.OrganizationId = dbo.WebsiteOrgTechnologies.OrganizationId AND Tech.Keyword = dbo.WebsiteOrgTechnologies.Technology

--CompanyContactsandTeams

INSERT INTO dbo.WebsiteOrganizationContacts(DecisionMakerId,OrganizationId,FirstName,LastName,Designation,Location,Url)

SELECT DISTINCT L.Id,L.OrganizationId,L.FirstName,L.LastName,L.ModifiedDesignation,L.country,L.url FROM  LinkedInData L WITH (NOLOCK)
inner join Organization O WITH (NOLOCK) on (O.Id = L.OrganizationId) INNER JOIN dbo.McDecisionmakerlist ON McDecisionmakerlist.DecisionMakerId = L.id
WHERE  OrganizationId IN (SELECT OrganizationId FROM  dbo.WebsiteOrganizations)


UPDATE dbo.WebsiteOrganizationContacts SET Team = TeamName FRom  cache.OrganizationTeams WHERE  OrganizationTeams.OrganizationId =WebsiteOrganizationContacts.OrganizationId

UPDATE dbo.WebsiteOrganizationContacts SET Functionality = m.Name FRom  dbo.McDecisionmakerlist m WHERE  m.DecisionMakerId = dbo.WebsiteOrganizationContacts.DecisionMakerId	

--OrganizationIntents

INSERT INTO dbo.WebsiteOrganizationIntents(IntentTopic,Category,Location,InvestmentType,Duration,OrganizationId)
SELECT DISTINCT    s.Functionality,s.TechnologyCategory,s.CountryName,s.InvestmentType,s.Duration,s.OrganizationId FROM SurgeSummary s WITH (NOLOCK)
WHERE s.OrganizationId IN (SELECT OrganizationId FROM  dbo.WebsiteOrganizations) AND s.TechnologyCategory != 'na'

--OrganizationTouchPoints

INSERT INTO dbo.WebsiteOrganizationTouchpoints(DecisionMakerId,OrganizationId,Touchpoint)

SELECT   DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'Work Anniversary - Next Month' FROM LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK) ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE  MONTH(CONVERT(DATE,l.DateOfJoining)) = MONTH(GETDATE()) + 1 AND YEAR(CONVERT(DATE,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints(DecisionMakerId,OrganizationId,Touchpoint)

SELECT  DISTINCT MC.DecisionMakerId,L.OrganizationId,'Work Anniversary - This Month'FROM LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK) ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE MONTH(CONVERT(DATE,l.DateOfJoining)) = MONTH(GETDATE())  AND YEAR(CONVERT(DATE,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints(DecisionMakerId,OrganizationId,Touchpoint)

SELECT  DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'Work Anniversary - Last Month' AS [Touch Point] FROM LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK) ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE MONTH(CONVERT(date,l.DateOfJoining)) = MONTH(GETDATE()) -1 AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints(DecisionMakerId,OrganizationId,Touchpoint)

SELECT DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'New Hire' AS [Touch Point] FROM	LinkedInDataNewHire l With (Nolock)
Inner Join McDecisionMakerListNewHire MC  With (Nolock) ON (l.Id = MC.DecisionMakerId)
Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE  CONVERT(date,l.DateOfJoining) > getdate() - 90


UPDATE dbo.WebsiteOrganizationTouchpoints SET  Functionality =  NAME FROM dbo.McDecisionmakerlistNewHire MCD
WHERE MCD.DecisionMakerId = dbo.WebsiteOrganizationTouchpoints.DecisionMakerId


END;
