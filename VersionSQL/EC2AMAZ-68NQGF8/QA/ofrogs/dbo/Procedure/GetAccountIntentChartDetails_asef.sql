/****** Object:  Procedure [dbo].[GetAccountIntentChartDetails_asef]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[GetAccountIntentChartDetails_asef] 
	-- Add the parameters for the stored procedure here
	@targetPersonaId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT FilterType, DataString1, DataCount, OrderNumber from TargetAccountIntentGraph
	where TargetPersonaId = @targetPersonaId
END
