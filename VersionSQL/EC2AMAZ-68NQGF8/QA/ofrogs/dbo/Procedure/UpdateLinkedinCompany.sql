/****** Object:  Procedure [dbo].[UpdateLinkedinCompany]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[UpdateLinkedinCompany]
@id int,
@organization varchar(max)

AS
BEGIN
	SET NOCOUNT ON;
	update linkedindata set organization=@organization where id=@id
End	
