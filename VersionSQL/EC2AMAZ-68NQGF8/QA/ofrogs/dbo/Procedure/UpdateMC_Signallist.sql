/****** Object:  Procedure [dbo].[UpdateMC_Signallist]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[UpdateMC_Signallist]
@name varchar(max),
@signalid int,
@appuserid int



AS
BEGIN
	SET NOCOUNT ON;
	if(@signalid = 0)
		delete from  McSignallist where name=@name and appuserid=@appuserid 
	else
		delete from  McSignallist where name=@name and appuserid=@appuserid and signalid= @signalid
	end
