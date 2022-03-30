/****** Object:  Procedure [dbo].[UpdateOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[UpdateOrganization]

@id int

AS
BEGIN
	SET NOCOUNT ON;
	update organization set IsActive=0 where id=@id;
	
		

	
End	
