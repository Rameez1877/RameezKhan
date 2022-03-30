/****** Object:  Procedure [dbo].[GetMagazineJson]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 1 Apr, 2016
-- Description:	Gets the Magazine Data in Json format.//
-- =============================================
-- [GetMagazineJson] 108
Create PROCEDURE [dbo].[GetMagazineJson]
	@MagazineId int
AS
BEGIN
	declare @IndustryId int 
	select @IndustryId = IndustryId from Magazine where Id = @MagazineId

	select 
		--I.*, 
		I.Id, I.Link, I.PubDate, I.Title, 
		S.Score, RS.Name as [SourceName]
	from 
		RssFeedItemScore S
		inner join RssFeedItem I on (I.Id = S.RssFeedItemId)
		inner join RssFeed F on (F.Id = I.RssFeedId)
		inner join RssSource RS on (RS.Id = F.RssSourceId)
	where
		S.TagId in (select TagId from MagazineTag where MagazineId = @MagazineId)
		and S.IndustryId = @IndustryId
		--and I.IsActive = 1
	order by 
		S.Score desc
	for JSON auto
	-- select top 100 *, 1200 as [Score] from RssFeedItem order by 1 desc 
END
