/****** Object:  Procedure [dbo].[RunRssFeedItemTagandIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[RunRssFeedItemTagandIndustry]
@RssFeedItemId int,
@tagid int,
@industryid int

AS
BEGIN
	SET NOCOUNT ON;
	
		insert RssFeedItemTag(RssFeedItemId, TagId, Confidencelevel,ConfidenceScore)
				values(@RssFeedItemId,@tagid,1,0.7);

       insert into RssFeedItemIndustry
		(RssFeedItemId,IndustryId)
             values(@RssFeedItemId,@industryid);

	
End	
