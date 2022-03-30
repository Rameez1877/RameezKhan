/****** Object:  Procedure [dbo].[QA_DeleteList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[QA_DeleteList] 
@TargetID INT = 0,
@MarketingID INT = 0
AS
BEGIN
SET NOCOUNT ON;

IF @TargetID <> 0
BEGIN
DELETE FROM TargetPersona WHERE ID = @TargetID
DELETE FROM DecisionMakersForMarketingList WHERE 
MarketingListID in (SELECT ID FROM MarketingLists WHERE TargetPersonaID = @TargetID)
DELETE FROM MarketingLists WHERE TargetPersonaID = @TargetID
END

ELSE IF @MarketingID <> 0 
BEGIN
DELETE FROM DecisionMakersForMarketingList WHERE 
MarketingListID in (SELECT ID FROM MarketingLists WHERE Id = @MarketingID)
DELETE FROM MarketingLists WHERE Id = @MarketingID
END


END
