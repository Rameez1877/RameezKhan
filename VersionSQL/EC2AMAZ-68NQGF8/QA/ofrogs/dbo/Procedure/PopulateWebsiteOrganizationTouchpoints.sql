/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationTouchpoints]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateWebsiteOrganizationTouchpoints]

AS
BEGIN
   

DECLARE @OrganizationId INT;

INSERT INTO dbo.WebsiteOrganizationTouchpoints
(
    DecisionMakerId,
    OrganizationId,
    Touchpoint
)

SELECT   DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'Work Anniversary - Next Month' 		
FROM	LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK)
ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE  MONTH(CONVERT(DATE,l.DateOfJoining)) = MONTH(GETDATE()) + 1 AND YEAR(CONVERT(DATE,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints
(
    DecisionMakerId,
    OrganizationId,
    Touchpoint
)

SELECT  DISTINCT MC.DecisionMakerId,L.OrganizationId,'Work Anniversary - This Month' 			
FROM	LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK)
ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE MONTH(CONVERT(DATE,l.DateOfJoining)) = MONTH(GETDATE())  AND YEAR(CONVERT(DATE,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints
(
    DecisionMakerId,
    OrganizationId,
    Touchpoint
)

SELECT  DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'Work Anniversary - Last Month' AS [Touch Point] FROM	LinkedInDataNewHire l WITH (NOLOCK)
INNER JOIN McDecisionMakerListNewHire MC  WITH (NOLOCK)
ON (l.Id = MC.DecisionMakerId)
INNER JOIN SurgeContactDetail sc  WITH (NOLOCK) ON (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE MONTH(CONVERT(date,l.DateOfJoining)) = MONTH(GETDATE()) -1 AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 

INSERT INTO dbo.WebsiteOrganizationTouchpoints
(
    DecisionMakerId,
    OrganizationId,
    Touchpoint
)
SELECT DISTINCT	MC.DecisionMakerId,L.OrganizationId, 'New Hire' AS [Touch Point] FROM	LinkedInDataNewHire l With (Nolock)
Inner Join McDecisionMakerListNewHire MC  With (Nolock) ON (l.Id = MC.DecisionMakerId)
Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
INNER JOIN dbo.WebsiteOrganizations ON WebsiteOrganizations.OrganizationId = sc.OrganizationId
WHERE  CONVERT(date,l.DateOfJoining) > getdate() - 90


UPDATE dbo.WebsiteOrganizationTouchpoints SET  Functionality =  NAME FROM dbo.McDecisionmakerlistNewHire MCD
WHERE MCD.DecisionMakerId = dbo.WebsiteOrganizationTouchpoints.DecisionMakerId

END;
