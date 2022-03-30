/****** Object:  Procedure [dbo].[SaveTargetPersonaOrganizations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveTargetPersonaOrganizations]
	@TargetPersonaId int, @UserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert into TargetPersonaOrganization (TargetPersonaId, OrganizationId)
	Select distinct @TargetPersonaId as TargetPersonaId, ID from CompanySearchResult where UserID = @UserId
END
