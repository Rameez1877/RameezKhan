/****** Object:  Procedure [dbo].[RemoveDecisionMakersForDeletedTargetAccount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<ASEF DAQIQ>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RemoveDecisionMakersForDeletedTargetAccount]
-- Add the parameters for the stored procedure here
@targetPersonaId int,
@organizationId int
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  -- Insert statements for procedure here
  WITH cte
  AS (SELECT
    dm.id
  FROM DecisionMakersForMarketingList dm,
       LinkedInData li,
       Tag t,
       MarketingLists ml
  WHERE dm.DecisionMakerId = li.id
  AND li.tagid = t.id
  AND dm.MarketingListId = ml.id
  AND ml.TargetPersonaId = @targetPersonaId
  AND t.OrganizationId = @organizationId)
  DELETE FROM DecisionMakersForMarketingList
  WHERE id IN (SELECT
      id
    FROM cte)

  EXEC PopulateMarketingListFilterSummary @targetPersonaId

END
