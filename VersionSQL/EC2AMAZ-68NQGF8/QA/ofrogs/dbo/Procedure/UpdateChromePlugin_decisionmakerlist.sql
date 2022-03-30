/****** Object:  Procedure [dbo].[UpdateChromePlugin_decisionmakerlist]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[UpdateChromePlugin_decisionmakerlist]
  @id int,
 @dmid int,
 @dmname varchar(5000),
 @appuserid int
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Name varchar(1000)
        SET @Name = 
        (
           select Name from McDecisionmaker where Id = @id
        )
insert into  McDecisionmakerlist (name,appuserid,decisionmakerid,decisionmakerlistname,isActive) values
                             (@Name,@appuserid,@dmid,@dmname,1)
		

	
End
