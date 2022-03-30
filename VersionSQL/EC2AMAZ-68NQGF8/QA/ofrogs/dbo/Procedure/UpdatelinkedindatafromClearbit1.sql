/****** Object:  Procedure [dbo].[UpdatelinkedindatafromClearbit1]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[UpdatelinkedindatafromClearbit1]
@suggested_domainname varchar(max),
@first_domainname varchar(max),
@id int
As
BEGIN
	SET NOCOUNT ON;
	

update  linkedindataforurl set suggested_domainname=@suggested_domainname ,  
firstsuggested_domainname= @first_domainname where id=@id



End
