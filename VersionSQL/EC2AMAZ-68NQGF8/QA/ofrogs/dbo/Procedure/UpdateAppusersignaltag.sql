/****** Object:  Procedure [dbo].[UpdateAppusersignaltag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[UpdateAppusersignaltag]
@id int,
@appuserid int

AS
BEGIN
	SET NOCOUNT ON;
	delete appusersignaltag where tagid=@id and appuserid=@appuserid 
End	
