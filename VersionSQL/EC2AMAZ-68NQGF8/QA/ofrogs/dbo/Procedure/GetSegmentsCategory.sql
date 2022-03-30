/****** Object:  Procedure [dbo].[GetSegmentsCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSegmentsCategory]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SubMarketingListNameDisplay as name from V_MarketingList
	
END
