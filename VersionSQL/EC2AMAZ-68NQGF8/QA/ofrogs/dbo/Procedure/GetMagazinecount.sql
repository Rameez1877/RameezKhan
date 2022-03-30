/****** Object:  Procedure [dbo].[GetMagazinecount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[GetMagazinecount]

As
Begin
delete from MagazineCountDetail
INSERT INTO MagazineCountDetail(MagazineId,MagazineName,MagazineCount)
	
  Select M.id,m.name, count(*) as NewsCount
		from 
				dbo.RssFeedItem I
				inner join dbo.RssFeedItemTag T on (T.RssFeedItemId = I.Id)
				inner join Magazinetag mt on (T.tagid = mt.tagid)
				inner join Magazine M on (mt.MagazineId = M.id)
				inner join dbo.RssFeed F on (F.Id = I.RssFeedId)
				inner join dbo.RssSource RS on (RS.Id = F.RssSourceId)
				inner join dbo.RssFeedItemIndustry RFII on RFII.RssFeedItemId = I.Id
		where
				T.TagId in (select TagId from MagazineTag 
				where MagazineId in(2127))
				and RFII.IndustryId = 28
				and T.ConfidenceScore > 0.7
				and RS.rssTypeID <> 3 
				and m.IsActive = 1
		group by m.name,M.id
		order by NewsCount desc
End
