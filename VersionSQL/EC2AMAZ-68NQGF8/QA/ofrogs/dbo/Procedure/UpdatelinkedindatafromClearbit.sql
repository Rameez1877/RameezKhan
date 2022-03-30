/****** Object:  Procedure [dbo].[UpdatelinkedindatafromClearbit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[UpdatelinkedindatafromClearbit]
@suggested_domainname varchar(max),
@first_domainname varchar(max),
@id int
As
BEGIN
	SET NOCOUNT ON;
	

update  linkedindata set suggested_domainname=@suggested_domainname ,  
firstsuggested_domainname= @first_domainname where id=@id



End
