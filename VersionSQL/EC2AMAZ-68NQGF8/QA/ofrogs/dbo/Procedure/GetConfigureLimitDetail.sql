/****** Object:  Procedure [dbo].[GetConfigureLimitDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetConfigureLimitDetail
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select NumberOfCountriesAllowed, NumberOfMarketingListsAllowed from AppUser
	where
	Id = @UserID
END
