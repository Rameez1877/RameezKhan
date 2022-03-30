/****** Object:  Procedure [dbo].[ProcessOrganizationFunding]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProcessOrganizationFunding]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ID INT
   SELECT @ID = max(id) FROM StgOrganizationFunding
   WHERE IsProcessed = 0 And OrganizationID is not null
   
  INSERT INTO FundingMarket(Name)
   SELECT market FROM StgOrganizationFunding
   WHERE Market Not IN (Select Name from FundingMarket)
      and len(Market) > 2
   GROUP BY market

   INSERT INTO FundingStage(Name)
   SELECT Stage FROM StgOrganizationFunding
   WHERE Stage Not IN (Select Name from FundingStage )
   and len(Stage) > 2
   GROUP BY Stage
 
   INSERT INTO OrganizationFunding
           (ID
           ,OrganizationID
           ,MarketID
           ,Signal
           ,Location
           ,StageID
           ,TotalRaised)
		   SELECT SOF.ID,
		   OrganizationID,
		   FM.ID MarketID,
		   Signal,
		   Location,
		   FS.ID StageID,
		   TotalRaised
		   FROM StgOrganizationFunding SOF
		   Left OUTER JOIN FundingStage FS on (FS.Name = SOF.Stage)
		   LEFT OUTER JOIN FundingMarket FM on (FM.Name = SOF.Market)
		   WHERE IsProcessed = 0 And OrganizationID is not null
		   AND SOF.Id <=@ID

		   Update StgOrganizationFunding
		   Set IsProcessed =1 
		   WHERE IsProcessed = 0 And OrganizationID is not null
		   AND Id <=@ID

END
