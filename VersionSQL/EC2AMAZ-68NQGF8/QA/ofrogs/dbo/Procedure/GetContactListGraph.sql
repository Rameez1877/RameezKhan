/****** Object:  Procedure [dbo].[GetContactListGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContactListGraph] 
	-- Add the parameters for the stored procedure here
	@targetPersonaId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CLG.FilterType, CLG.DataValues, CLG.RecordCount, M.Marketinglistname
	 From ContactListGraphDetail CLG, Marketinglists M

		WHERE CLG.MarketingListId = M.id
		AND CLG.MarketingListId = @targetPersonaId
		order by RecordCount desc
END
