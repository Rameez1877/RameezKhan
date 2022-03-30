/****** Object:  Procedure [dbo].[UpdateChromePlugin1]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[UpdateChromePlugin1]
 @id int
AS
BEGIN
	SET NOCOUNT ON;
	

update  linkedindataforurl set currentposition=replace(currentposition,'?','') , 
                          summary=replace(summary,'?','') , 
                          organization=replace(organization,'?',''),
                            designation=replace(designation,'?','') where id=@id
		

	
End
