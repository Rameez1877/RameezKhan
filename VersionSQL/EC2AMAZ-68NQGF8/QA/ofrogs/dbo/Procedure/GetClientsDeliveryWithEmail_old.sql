/****** Object:  Procedure [dbo].[GetClientsDeliveryWithEmail_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetClientsDeliveryWithEmail_old]
	@UserId int
AS
/*
[GetClientsDeliveryWithEmail] 5523
*/
BEGIN

  SET NOCOUNT ON;
  ;
  WITH CTE (A, B, C)
  AS (SELECT
    TP.CreatedBy,
    AU.Name,
    COUNT(Distinct TPO.OrganizationId)
  FROM TargetPersona TP
  INNER JOIN TargetPersonaOrganization TPO
    ON TP.Id = TPO.TargetPersonaId
  INNER JOIN AppUser AU
    ON (AU.Id = TP.CreatedBy)
  GROUP BY CreatedBy,
           AU.Name),
  DECCTE (CRE, NA, CO, tpname)
  AS (SELECT
    TP.CreatedBy,
    AU.Name,
    COUNT(DISTINCT DML.LinkedInUrl),
    tp.name
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
  --INNER JOIN SurgeContactDetail SG
  --ON SG.LinkedinId = DML.DecisionMakerId
  --WHERE SG.EmailId IS NOT NULL AND SG.EmailId <> '' AND SG.EmailId <> ' '
  GROUP BY TP.CreatedBy,
           AU.Name,
           tp.name)
  SELECT DISTINCT
    AU.ID,
    AU.Name,
    C OrganizationCount,
    CO DecisionMakerCount,
    COUNT(TP.Id) TotalTargetPersona,
    tpname AS TargetPersonaName INTO #results
  FROM CTE
  FULL JOIN DECCTE
    ON A = CRE
  INNER JOIN AppUser AU
    ON AU.Id = A
    OR AU.Id = CRE
  INNER JOIN TARGETPERSONA TP
    ON TP.CreatedBy = AU.ID
  GROUP BY AU.ID,
           AU.Name,
           C,
           CO,
           tpname
  ORDER BY AU.ID DESC

  SELECT
	R.Id,
    R.[Name],
    R.organizationCount AS TotalAccountsDelivered,
    ISNULL(SUM(R.DecisionMakerCount), 0) AS TotalDMsDelivered,
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
  FROM #results R
  left outer join Subscriptions S on R.Id = S.UserId
  where
	R.Id = @UserId or @UserId is null
  GROUP BY R.Id, R.[Name],R.organizationCount, S.EndDate, S.StartDate, S.NumberOfNudges, 
	S.NumberOfAccounts,
	S.NumberOfContacts,
	S.TechnologyIntelligence, 
	S.AccountScoring,
	S.SecondaryResearchBasedIntent,
	S.TouchPoints, 
	s.CRMIntegration
END
