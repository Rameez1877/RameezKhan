/****** Object:  Procedure [dbo].[Updatelinkedindataforurl_active]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[Updatelinkedindataforurl_active]
  @groupid int
 
AS
BEGIN
	
update GrayMatterCRmDataNonAAPLus set isActive=1 where id=@groupid
		

	
End
