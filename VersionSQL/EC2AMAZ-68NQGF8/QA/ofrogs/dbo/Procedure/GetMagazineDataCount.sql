/****** Object:  Procedure [dbo].[GetMagazineDataCount]    Committed by VersionSQL https://www.versionsql.com ******/

   CREATE PROCEDURE [dbo].[GetMagazineDataCount]
   @pubDate date


   As
	 declare @LabelId int 
	select @LabelId = LabelId from Magazine where IndustryId = 36
	
	if(@LabelId is not null)
	Begin
	select min(Id) as Id,Link,PubDate,Title,Description,TopicNames,max(Score) as Score,min(SourceName) SourceName from
	(
		select RFI.Id,RFI.Link,RFI.PubDate,RFI.Title,RFI.Description,dbo.GetTopicNames(RFI.Id) as TopicNames,CS.Score,RS.Name as SourceName 
		from
		dbo.Magazine M join Label L on M.LabelId = L.Id
		join dbo.Category C on C.LabelId = L.Id
		join dbo.CategoryScore CS on CS.CategoryId = C.Id
		join dbo.RssFeedItem RFI on RFI.Id = CS.RssFeedItemId
		join dbo.RssFeed RF on RFI.RssFeedId = RF.Id
		join dbo.RssSource RS on RF.RssSourceId = RS.Id and RS.IndustryId = 36 
		where C.IndustryId = 36 and CS.Score >= L.thresholdscore  and L.Id = @LabelId
	) R
	where format(PubDate,'yyyy-MM-dd')=@pubdate
		group by Link,Pubdate,Title,Description,TopicNames
		order by PubDate desc;
	End
	else -- now this means it is a magazine for an organization
	Begin
		select min(Id) as Id,Link,PubDate,Title,Description, TopicNames,
		max(Score) Score,min(SourceName) SourceName 
		from

		(
			
			select Top (100000)
				I.Id, I.Link, I.PubDate, I.Title, I.[Description], ISNULL(dbo.[GetSignalNames](I.Id),'') as [TopicNames],
				0.3 as Score, RS.Name as [SourceName]
				
			from 
				dbo.RssFeedItem I
				inner join dbo.RssFeedItemTag T on (T.RssFeedItemId = I.Id)
				inner join dbo.RssFeed F on (F.Id = I.RssFeedId)
				inner join dbo.RssSource RS on (RS.Id = F.RssSourceId)
				--inner join Topic Tp on Tp.RssFeedItemId = I.Id
				--LEFT OUTER join Topic Tp on Tp.RssFeedItemId = I.Id
				inner join dbo.RssFeedItemIndustry RFII on RFII.RssFeedItemId = I.Id
			where
				 RFII.IndustryId = 36
				and T.ConfidenceScore > 0.7
				and RS.rssTypeID <> 3
				
			ORDER BY I.id DESC
		) R
		where format(PubDate,'yyyy-MM-dd')=@pubdate
		group by Link,Pubdate,Title,Description, TopicNames
		order by Score desc;




		End
