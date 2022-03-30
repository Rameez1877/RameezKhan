/****** Object:  Procedure [dbo].[Sp_Delete_Target_Persona]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sp_Delete_Target_Persona
@UserId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   delete from TargetPersonaTechnology WHERE TargetPersonaID in (
select id from targetpersona where createdby = @UserID)


delete from TargetPersonaGIC WHERE TargetPersonaID in (
select id from targetpersona where createdby = @UserID)


delete from TargetPersonaCountry WHERE TargetPersonaID in (
select id from targetpersona where createdby = @UserID)
delete from TargetPersonaIndustry WHERE TargetPersonaID in (
select id from targetpersona where createdby = @UserID)

delete from TargetPersonaOrganization WHERE TargetPersonaID in (
select id from targetpersona where createdby = @UserID)

delete from targetpersona where createdby = @UserID
END
