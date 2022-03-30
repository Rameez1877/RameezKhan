/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationIntents]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE PopulateWebsiteOrganizationIntents

AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   

DECLARE @OrganizationId INT

DECLARE Intents CURSOR FOR SELECT OrganizationId FROM WebsiteOrganizations

OPEN Intents

FETCH NEXT FROM Intents INTO @OrganizationId

WHILE @@FETCH_STATUS=0



INSERT INTO dbo.WebsiteOrganizationIntents
(
    IntentTopic,
    Category,
    Location,
    InvestmentType,
    Duration,
    OrganizationId
)

 SELECT DISTINCT TOP 20
      
          s.Functionality,
          s.TechnologyCategory,
          s.CountryName,
		  s.InvestmentType,
          s.Duration,
		  s.OrganizationId
        FROM SurgeSummary s WITH (NOLOCK)
		  WHERE s.OrganizationId = @OrganizationId


FETCH NEXT FROM Intents INTO @OrganizationId

CLOSE Intents
DEALLOCATE Intents

UPDATE dbo.WebsiteOrganizationIntents SET Team =c.TeamName FROM cache.OrganizationTeams c
WHERE dbo.WebsiteOrganizationIntents.OrganizationId = c.OrganizationId

END;
