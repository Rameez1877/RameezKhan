/****** Object:  Procedure [dbo].[Update_appuserindustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Update_appuserindustry]
@id int,@industryId varchar(max)

AS
BEGIN
	SET NOCOUNT ON;
	delete from appuserindustry where userid=@id
	insert into appuserindustry values(@id,@industryId ,0)
	
End	
