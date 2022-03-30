/****** Object:  Procedure [dbo].[Update_zbemail_status]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Update_zbemail_status]
 @id int,
 @status varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	

update  zb_email set status=@status where id=@id
		

	
End
