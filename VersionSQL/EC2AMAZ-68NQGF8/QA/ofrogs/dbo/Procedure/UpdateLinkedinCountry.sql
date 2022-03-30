/****** Object:  Procedure [dbo].[UpdateLinkedinCountry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[UpdateLinkedinCountry]
@id int,@country varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
		
	update linkedindata set country=@country where id=@id
End	
