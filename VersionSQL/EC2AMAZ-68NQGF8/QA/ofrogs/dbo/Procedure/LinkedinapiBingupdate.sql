/****** Object:  Procedure [dbo].[LinkedinapiBingupdate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[LinkedinapiBingupdate]
 @id int
AS
BEGIN
	SET NOCOUNT ON;	
	update linkedinapi_Bing set IsActive=0, Rundate = getdate() where id=@id;		
End
