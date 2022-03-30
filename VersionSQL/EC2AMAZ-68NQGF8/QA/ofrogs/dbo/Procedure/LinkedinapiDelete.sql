/****** Object:  Procedure [dbo].[LinkedinapiDelete]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[LinkedinapiDelete]

@id int

AS
BEGIN
	SET NOCOUNT ON;
	delete from linkedinapi where id=@id
	
End	
