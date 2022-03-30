/****** Object:  Procedure [dbo].[UpdateChromePlugin]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[UpdateChromePlugin]
 @id int
AS
BEGIN
	SET NOCOUNT ON;
	

update  linkedindata set currentposition=replace(currentposition,'?','') , 
                          summary=replace(summary,'?','') , 
                          organization=replace(organization,'?',''),
                            designation=replace(designation,'?','') where id=@id
		

	
End
