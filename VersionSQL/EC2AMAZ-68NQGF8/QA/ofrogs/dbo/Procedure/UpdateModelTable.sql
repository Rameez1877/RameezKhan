/****** Object:  Procedure [dbo].[UpdateModelTable]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateModelTable 
	@RssFeedItemId int = 0
AS
BEGIN
	
	-- 1. Get RssFeed
	-- 2. Get IndustryIds
	-- 3. Insert industryids into model table
	-- 4. Get TagId
	-- 5. Insert into Model table
	-- 5. GetScore based on GoodWords
	-- 6. Update score into score table
	-- 7. Truncated the Model table
	declare @News nvarchar(max)
	select @News = [Description] from RssFeedItem where Id = @RssFeedItemId

	select T.Id as TagId, IT.IndustryId, T.Name 
	into #TempModel
	from 
		Tag T
		inner join IndustryTag IT on (T.Id = IT.TagId)
		inner join Organization O on (O.Name = T.Name)
	where 
		CHARINDEX(T.Name, @News) > 0

	insert RssFeedItemModel(RssFeedItemId, TagId, IndustryId)
	select @RssFeedItemId, TagId, IndustryId
	from
		#TempModel
END
