/****** Object:  Procedure [dbo].[QA_GetSurgeDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetSurgeDashboardData]
	-- Add the parameters for the stored procedure here
	@UserId Int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from SurgeDashBoard
	Where UserID = @UserId
END
