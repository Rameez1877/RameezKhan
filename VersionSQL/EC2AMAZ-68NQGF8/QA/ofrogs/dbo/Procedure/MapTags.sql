/****** Object:  Procedure [dbo].[MapTags]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[MapTags]
	@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @News nvarchar(max)
	select @News = [Description] from RssFeedItem where Id = @RssFeedItemId
	
	-- delete from RssFeedItemTag where RssFeedItemId = @RssFeedItemId

	insert RssFeedItemTag(RssFeedItemId, TagId)
	select distinct @RssFeedItemId, T.Id
	from 
		Tag T
		inner join Organization O on (O.Name = T.Name)
	where 
		CHARINDEX(T.Name, @News) > 0
END
