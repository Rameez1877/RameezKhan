/****** Object:  Procedure [dbo].[Updatetargetcustomer]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Updatetargetcustomer]

@appuserid int,
@orgid int


AS
BEGIN
	SET NOCOUNT ON;
	update ofuser.customertargetlist set IsActive=0 , IsExistingCustomer=0 , ExistingCustomer='No' where AppUserId=@appuserid and OrganizationId=@orgid;
	
End	
