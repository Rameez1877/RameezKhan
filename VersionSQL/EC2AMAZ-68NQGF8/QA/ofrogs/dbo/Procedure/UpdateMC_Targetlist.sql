/****** Object:  Procedure [dbo].[UpdateMC_Targetlist]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[UpdateMC_Targetlist]
@name varchar(max),
@targetid int,
@appuserid int



AS
BEGIN
	SET NOCOUNT ON;
	if(@targetid = 0)
		delete from  McTargetlist where name=@name and appuserid=@appuserid 
	else
		delete from  McTargetlist where name=@name and appuserid=@appuserid and targetid= @targetid
	end
