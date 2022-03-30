/****** Object:  Procedure [dbo].[UpdateEmailTable]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[UpdateEmailTable]
 @id int
AS
BEGIN
	SET NOCOUNT ON;
	

update  EmailTable set IsValid=1 where id=@id
		

	
End
