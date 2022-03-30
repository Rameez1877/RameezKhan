/****** Object:  Procedure [dbo].[GetMagazineDataCopy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMagazineDataCopy]  
 @MagazineId int,  
 @Offset int = 0,  
 @Limit int = 1000  
AS  
-- =============================================  
-- Author:  Anurag Gandhi  
-- Create date: 29 Feb, 2016  
-- Updated date: 06 April, 2017  
-- Description: Gets the Magazine Data.//  
-- =============================================  
-- [GetMagazineData] 1529, 5, 10  
BEGIN  
 declare @IndustryId int,@LabelId int   
 select @IndustryId = IndustryId,@LabelId = LabelId from Magazine where Id = @MagazineId  
   
 --If Label ID is not null, that means we will send back magazine data for a topic that is not an 'Organization'  
 if(@LabelId is not null)  
 Begin  
 select min(Id) as Id,Link,PubDate,Title,TagName, Description,IsNull(TopicNames,'')as TopicNames,max(Score) as Score,min(SourceName) SourceName from  
 (  
        select RFI.Id,RFI.Link,RFI.PubDate,RFI.Title,Tag.Name as TagName, RFI.Description,ISNULL(dbo.GetTopicNames(RFI.Id),'') as TopicNames,CS.Score,RS.Name as SourceName   
  from  
  dbo.Magazine M join Label L on M.LabelId = L.Id  
  join dbo.Category C on C.LabelId = L.Id  
  join dbo.CategoryScore CS on CS.CategoryId = C.Id  
  join dbo.RssFeedItem RFI on RFI.Id = CS.RssFeedItemId  
  join dbo.RssFeed RF on RFI.RssFeedId = RF.Id  
  join dbo.RssSource RS on RF.RssSourceId = RS.Id --and RS.IndustryId = 36 --Vinayed reviewed it.
  full outer join Tag on tag.id = cs.tagId  
  where C.IndustryId = @IndustryId and CS.Score >= L.thresholdscore  and L.Id = @LabelId   
 --- and (year(RFI.PubDate)=year(getdate()) or year(RFI.PubDate)=year(getdate())-1 )  
 ) R  
  group by Link,Pubdate,Title,Description,TopicNames, TagName 
  order by PubDate desc   
  OFFSET @Offset ROWS  
  FETCH NEXT @Limit ROWS ONLY;  
 End  
 else -- now this means it is a magazine for an organization  
 Begin  
  select min(Id) as Id,Link,PubDate,Title,Description,   
  IsNull(TopicNames,'')as TopicNames,  
    
  max(Score) Score,min(SourceName) SourceName   
  from  
  
  (  
   /*  
   select   
    --I.*,   
    --I.Id, I.Link, I.PubDate, I.Title, I.[Description], dbo.[GetTopicNames](I.Id) as [TopicNames],  
    I.Id, I.Link, I.PubDate, I.Title, I.[Description], '' as [TopicNames],  
    -- I.RssFeedId, null as [Description], null as [Guid], null as Tags, I.IsActive, I.StatusId,   
    S.Score, RS.Name as [SourceName]  
   from   
    CategoryScore S  
    inner join RssFeedItem I on (I.Id = S.RssFeedItemId)  
    inner join RssFeedItemTag T on (T.RssFeedItemId = I.Id)  
    inner join RssFeed F on (F.Id = I.RssFeedId)  
    inner join RssSource RS on (RS.Id = F.RssSourceId)  
    inner join category C on C.id = s.CategoryId  
    inner join OutputIndustrySignalAnalysis Ops on I.Id = Ops.rssFeedItemId and Ops.tagID = T.TagId  
   where  
    T.TagId in (select TagId from MagazineTag where MagazineId = @MagazineId)  
    and C.IndustryId = @IndustryId  
    and S.Score >= 0.5  
    --and I.IsActive = 1  
  
   union  
   */  
  
   select Top (@Limit)  
    I.Id, I.Link, I.PubDate, I.Title, I.[Description], ISNULL(dbo.[GetSignalNames](I.Id),'') as [TopicNames],  
   --- I.Id, I.Link, I.PubDate, I.Title, I.[Description], dbo.[GetTopicNames](I.Id) as [TopicNames],  
   --- I.Id, I.Link, I.PubDate, I.Title, I.[Description], '' as [TopicNames],  
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
    T.TagId in (select TagId from MagazineTag where MagazineId = @MagazineId)  
    and RFII.IndustryId = @IndustryId  
    and T.ConfidenceScore > 0.7  
    and RS.rssTypeID <> 3   
    --and (year(I.PubDate)=year(getdate()) or year(I.PubDate)=year(getdate())-1 )  
   ORDER BY I.id DESC  
  ) R  
  group by Link,Pubdate,Title,Description, TopicNames   
  order by Score desc  
  OFFSET @Offset ROWS  
  FETCH NEXT @Limit ROWS ONLY;  
  
  End  
END  
  
  
  
  
  
  
  
  
  
  
  
  
