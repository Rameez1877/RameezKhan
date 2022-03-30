/****** Object:  Procedure [dbo].[Updatelinkedinprofile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Updatelinkedinprofile]

@id varchar(max),@userid int

AS
BEGIN
	SET NOCOUNT ON;
	update linkedindata set userid=0 where id in (@id);
	update linkedindata set keyword='Consumer' where  designation like '% Consumer %'  
    update linkedindata set keyword='Operation' where  designation like '% Operation %'  
    update linkedindata set keyword='Marketing' where  designation like '% Marketing %'  
    update linkedindata set keyword='Customer' where  designation like '% Customer %' 
		

	
End	
