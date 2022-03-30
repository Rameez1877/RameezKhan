/****** Object:  Procedure [dbo].[UpdateMC_list]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[UpdateMC_list]

@orgid int,
@appuserid int



AS
BEGIN
	SET NOCOUNT ON;
	
		delete from  marketingcampaign where AppUserid=@appuserid and id= @orgid
	
End
