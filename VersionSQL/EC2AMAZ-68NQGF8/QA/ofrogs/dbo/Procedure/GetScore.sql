/****** Object:  Procedure [dbo].[GetScore]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 5th June, 2016
-- Description:	Stored Procedure to Generate Score out of RootWords for News Item
-- =============================================
CREATE PROCEDURE [dbo].[GetScore]
	@RssFeedItemId int,
	@OverWriteDTM bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	IF (select count(1) from DocumentTermMatrix where RssFeedItemId = @RssFeedItemId) = 0 or @OverWriteDTM = 1
	BEGIN
		exec dbo.GenerateDTM @RssFeedItemId
	END
	
	declare @News nvarchar(max)
	select @News = [Description] from RssFeedItem where Id = @RssFeedItemId

	select T.Id as TagId, O.IndustryId, T.Name 
	into #TempModel
	from 
		Tag T
		-- inner join IndustryTag IT on (T.Id = IT.TagId)
		inner join Organization O on (O.Name = T.Name)
	where 
		CHARINDEX(T.Name, @News) > 0
    
	IF (select count(*) from #TempModel) = 0
	Begin
		print('no industry found')
	End
	Else
	Begin
		declare @TagId int, @IndustryId int
		select top 1 @TagId = TagId, @IndustryId = IndustryId from #TempModel

		-- select D.Word, (D.Frequency) * 1000 as Score, G.IndustryId
		select sum(D.Frequency) * 1000 as Score
		from 
			DocumentTermMatrix D
			inner join GoodWord G on (D.Word = G.RootWord)
		where
			G.IndustryId = @IndustryId
			and D.RssFeedItemId = @RssFeedItemId
	End
END
