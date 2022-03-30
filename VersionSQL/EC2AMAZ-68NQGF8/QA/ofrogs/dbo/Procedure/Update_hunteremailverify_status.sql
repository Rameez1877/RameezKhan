/****** Object:  Procedure [dbo].[Update_hunteremailverify_status]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[Update_hunteremailverify_status]
 @id int,
 @status varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	

update  zb_email set status1=@status where id=@id
		

	
End
