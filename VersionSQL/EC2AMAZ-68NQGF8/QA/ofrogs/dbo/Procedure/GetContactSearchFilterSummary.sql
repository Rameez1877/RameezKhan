/****** Object:  Procedure [dbo].[GetContactSearchFilterSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daiq>
-- Create date: <3 Aug 2021>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContactSearchFilterSummary] @TargetPersonaId int
/*
GetContactSearchFilterSummary 30385
qa_GetContactSearchFilterSummary 30385
*/
AS
BEGIN


DECLARE @PersonaIDs VARCHAR(200), @RegionIDs  VARCHAR(200)
SELECT @PersonaIDs = PersonaIDs , @RegionIDs = RegionIDs FROM TargetPersona WHERE ID = @TargetPersonaId 

SELECT VALUE INTO #P FROM string_split(@PersonaIDs,',')
SELECT VALUE INTO #R FROM string_split(@RegionIDs,',')

SELECT ID INTO #CountryID from country where IsRegion IN (SELECT * FROM #R)


  SET NOCOUNT ON;
  SELECT DISTINCT
    'Functionality' AS FilterType,
	LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(MP.Intent, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) AS DataValues,
    NULL AS Code,
    NULL AS CountryId
	FROM #P P 
	INNER JOIN MASTER.PersonaFunctionalityForDecisionMakers MP ON MP.PersonaID = P.value
	INNER JOIN Master.ContactListSummary C ON C.TypeID = MP.IntentID
  INNER JOIN TargetPersonaOrganization t with (nolock)
    ON (C.OrganizationId = T.OrganizationId)
  AND t.TargetPersonaId = @TargetPersonaId
  INNER JOIN #CountryID CI ON CI.ID = C.ResultantCountryId
  WHERE MP.IsActive = 1
  UNION
  SELECT DISTINCT
    'Country' AS FilterType,
	LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(CO.NAME, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) AS DataValues,
    CO.Code,
    CO.Id AS CountryId
  FROM Master.ContactListSummary C
	INNER JOIN MASTER.PersonaFunctionalityForDecisionMakers MP ON MP.IntentID = C.TYPEID
	INNER JOIN #P P ON P.value = MP.PersonaID
  INNER JOIN TargetPersonaOrganization t with (nolock)
    ON (C.OrganizationId = T.OrganizationId)
  AND t.TargetPersonaId = @TargetPersonaId
  INNER JOIN Country CO ON CO.ID = C.ResultantCountryId
  INNER JOIN #CountryID CI ON CI.ID = CO.ID
  WHERE ResultantCountryId IS NOT NULL AND MP.IsActive = 1
END
