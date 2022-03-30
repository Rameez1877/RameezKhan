/****** Object:  Procedure [dbo].[sp_linkedindata_update_decisionmaker]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Janna
-- Create date: 25th Sep 2018
-- Description:	Update Decision Maker In LinkedInData Table
-- =============================================
CREATE PROCEDURE [dbo].[sp_linkedindata_update_decisionmaker]
-- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
  
	--Influencer	
    UPDATE linkedindata  
    SET decisionmaker = 'Influencer'
    WHERE id IN (SELECT
        id
    FROM linkedindata
    WHERE EXISTS (SELECT
     *
    FROM InfluencerList
    WHERE isactive = 1
    AND CHARINDEX(keyword, summary) > 0)
    AND decisionmaker <> 'Champions')
	--DecisionMaker
    UPDATE linkedindata
    SET decisionmaker = 'DecisionMaker'
    WHERE id IN (SELECT
        id
    FROM linkedindata
    WHERE EXISTS (SELECT
        *
    FROM decisionmakerlist
    WHERE isactive = 1
    AND CHARINDEX(keyword, summary) > 0)
    AND decisionmaker <> 'Champions')
	--Others
	UPDATE linkedindata
    SET decisionmaker = 'Unknown'
	WHERE decisionmaker not in ('Champions','DecisionMaker','Influencer')
END
