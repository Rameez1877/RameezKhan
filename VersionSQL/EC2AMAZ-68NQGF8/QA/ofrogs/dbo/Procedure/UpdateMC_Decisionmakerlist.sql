/****** Object:  Procedure [dbo].[UpdateMC_Decisionmakerlist]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[UpdateMC_Decisionmakerlist]
@name varchar(max),
@decisionmakerid int,
@appuserid int



AS
BEGIN
	SET NOCOUNT ON;
	if(@decisionmakerid = 0)
		delete from  McDecisionmakerlist where name=@name and appuserid=@appuserid 
	else
		delete from  McDecisionmakerlist where name=@name and appuserid=@appuserid and decisionmakerid= @decisionmakerid
	end
