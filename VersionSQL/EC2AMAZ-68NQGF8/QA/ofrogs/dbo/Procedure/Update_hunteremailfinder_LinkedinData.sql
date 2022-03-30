/****** Object:  Procedure [dbo].[Update_hunteremailfinder_LinkedinData]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[Update_hunteremailfinder_LinkedinData]
 @id int,
 @emailid varchar(max),
 @score int
AS
BEGIN
	SET NOCOUNT ON;

update  LinkedInData set emailid=@emailid,score=@score where id=@id

End
