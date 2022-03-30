/****** Object:  Procedure [dbo].[Linkedinapiupdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Linkedinapiupdate]
 @id int
AS
BEGIN
	SET NOCOUNT ON;	
	update linkedinapi set IsActive=0, Rundate = getdate() where id=@id;		
End
