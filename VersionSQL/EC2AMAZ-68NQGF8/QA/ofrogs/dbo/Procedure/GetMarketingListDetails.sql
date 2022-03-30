/****** Object:  Procedure [dbo].[GetMarketingListDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMarketingListDetails] @UserId int
AS
BEGIN
  SET NOCOUNT ON;

  SELECT
    ml.Id,
    ml.TargetPersonaId,
    ml.MarketingListName,
    ml.TotalAccounts,
    ml.TotalDecisionMakers,
    REPLACE(ml.Locations, ',', ', ') Locations,
    REPLACE(ml.Seniority, ',', ', ') Seniority,
    REPLACE(ml.Functionality, ',', ', ') Functionality,
	ml.Functionality as Functionality2,
    ml.CreateDate,
    tp.[Name],
    REPLACE(tp.Industries, ',', ', ') Industries,
    REPLACE(tp.Technologies, ',', ', ') Technologies,
    REPLACE(tp.Gics, ',', ', ') Gics,
    REPLACE(tp.Revenues, ',', ', ') Revenues,
    REPLACE(tp.EmployeeCounts, ',', ', ') EmployeeCounts
  FROM MarketingLists ml,
       TargetPersona tp
  WHERE ml.TargetPersonaId = tp.Id
  AND ml.CreatedBy = @UserId
  ORDER BY ml.Id DESC


END
