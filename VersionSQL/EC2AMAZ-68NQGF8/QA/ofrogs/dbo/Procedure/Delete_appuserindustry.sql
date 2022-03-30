/****** Object:  Procedure [dbo].[Delete_appuserindustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Delete_appuserindustry]
@id int 
AS
BEGIN
	SET NOCOUNT ON;


	delete from appuserindustry where userid=@id
	delete from ofuser.customertargetlist where appuserid=@id
End	
