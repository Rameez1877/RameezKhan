/****** Object:  Procedure [dbo].[GetClientsDeliveryWithEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetClientsDeliveryWithEmail]
	@UserId int
AS
/*
[GetClientsDeliveryWithEmail] 301
*/
BEGIN

  SET NOCOUNT ON;
 SELECT
    TP.CreatedBy as Id,
	AU.Name, 
    COUNT(DISTINCT DML.OrganizationId) TotalAccountsDelivered,
	COUNT(DISTINCT DML.LinkedInUrl) TotalDMsDelivered
	into #result
  FROM TargetPersona TP
  INNER JOIN MarketingLists ML
    ON TP.Id = ML.TargetPersonaId
  INNER JOIN DecisionMakersForMarketingList DML
    ON (DML.MarketingListId = ML.Id
    AND DML.EmailId IS NOT NULL
    AND DML.EmailId <> ''
    AND DML.EmailId <> ' ')
  INNER JOIN AppUser AU
    ON AU.Id = TP.CreatedBy
  GROUP BY TP.CreatedBy, AU.Name

  SELECT
	R.Id,
    R.[Name],
    ISNULL(R.TotalAccountsDelivered, 0) AS TotalAccountsDelivered,
    ISNULL(R.TotalDMsDelivered, 0) AS TotalDMsDelivered,
	S.EndDate,
	S.StartDate,
	S.NumberOfNudges, 
	S.NumberOfAccounts,
	S.NumberOfContacts,
	S.TechnologyIntelligence, 
	S.AccountScoring,
	S.SecondaryResearchBasedIntent,
	S.TouchPoints, 
	s.CRMIntegration
OneHrConsultancy
  FROM #result R
  left outer join Subscriptions S on R.Id = S.UserId
  where
	R.Id = @UserId or @UserId is null

END
