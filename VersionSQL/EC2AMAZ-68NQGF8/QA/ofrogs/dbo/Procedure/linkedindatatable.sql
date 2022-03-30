/****** Object:  Procedure [dbo].[linkedindatatable]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[linkedindatatable]

@id int,@country varchar(max),@domain varchar(max)

AS
BEGIN
	SET NOCOUNT ON;
	update linkedindata set suggested_domainname=@domain,linkedin_country=@country where id=@id;
	
		

	
End	
