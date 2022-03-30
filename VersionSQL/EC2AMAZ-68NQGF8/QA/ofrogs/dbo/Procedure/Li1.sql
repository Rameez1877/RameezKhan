/****** Object:  Procedure [dbo].[Li1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<ASEF>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetChampionDetail]  
	-- Add the parameters for the stored procedure here
	@orgId int, 
	@userId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @organizationId int, @Uid int

    -- Insert statements for procedure here
	select * from OrganizationChampionDetail o 
	where o.TrackedOrganizationId = @orgId and o.UserID = @userId
	order by  o.IsChampion desc, o.URL, o.linkedinid desc
END
