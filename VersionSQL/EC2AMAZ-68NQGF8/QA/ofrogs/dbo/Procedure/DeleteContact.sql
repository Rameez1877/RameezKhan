/****** Object:  Procedure [dbo].[DeleteContact]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<SP to delete the decision makers and update the count accordingly>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteContact] @LinkedInId int, @MarketingListId int
AS
BEGIN

  SET NOCOUNT ON;

  DELETE FROM DecisionMakersForMarketingList
  WHERE DecisionMakerId = @LinkedInId
    AND MarketingListId = @MarketingListId

  SELECT DISTINCT
    Marketinglistid,
    COUNT(DISTINCT LinkedInUrl) AS NumberofDecisionMakers,
    COUNT(DISTINCT OrganizationId) AS NumberofAccounts INTO #tempProfile
  FROM DecisionMakersForMarketingList
  WHERE MarketingListId = @MarketingListId
  GROUP BY marketinglistId


  IF EXISTS (SELECT TOP 1
      1
    FROM #tempProfile)
  BEGIN
    UPDATE m
    SET m.totalDecisionMakers = t.NumberofDecisionMakers,
        m.TotalAccounts = t.NumberofAccounts
    FROM marketinglists m
    INNER JOIN #tempProfile t
      ON (t.MarketingListId = m.id)
  END
  ELSE
  BEGIN
    DELETE FROM MarketingLists
    WHERE id = @MarketingListId
  END
END
