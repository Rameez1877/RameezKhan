/****** Object:  Procedure [dbo].[GetMagazineData_automail]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[GetMagazineData_automail] --  2147  

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

select min(Id) as Id,Link,PubDate,Title,Name as TagName, Description,IsNull(TopicNames,'')as TopicNames,max(Score) as Score,min(SourceName) SourceName from      

(      

        select RFI.Id,RFI.Link,RFI.PubDate,RFI.Title,t.name,RFI.Description,ISNULL(dbo.GetTopicNames(RFI.Id),'') as TopicNames,CS.Score,RS.Name as SourceName       

  from      

  dbo.Magazine M join Label L on M.LabelId = L.Id      

  join dbo.Category C on C.LabelId = L.Id      

  join dbo.CategoryScore CS on CS.CategoryId = C.Id      

  join dbo.RssFeedItem RFI on RFI.Id = CS.RssFeedItemId      

  join dbo.RssFeed RF on RFI.RssFeedId = RF.Id      

  join dbo.RssSource RS on RF.RssSourceId = RS.Id --and RS.IndustryId = 36 --Vinayed reviewed it.      

  --left outer join rssfeeditemtag rfit on rfit.rssfeeditemid = rfi.id       

  --join tag t on t.id = rfit.tagid     

  --left outer join industrytag it on C.industryid = it.industryid      

  left outer join Tag t on t.id = cs.tagid    

  where c.industryid = @industryID and CS.Score >= L.thresholdscore  and L.Id = @LabelId --and t.tagtypeid = 1        

 --- and (year(RFI.PubDate)=year(getdate()) or year(RFI.PubDate)=year(getdate())-1)      

 ) R      

  group by Link,Pubdate,Title,Description,TopicNames, name      

  order by PubDate desc       

  OFFSET @Offset ROWS      

  FETCH NEXT @Limit ROWS ONLY;      

 End      

  

 else -- now this means it is a magazine for an organization      

 Begin      

  select min(Id) as Id,Link,PubDate,Title,Name as TagName, Description,IsNull(TopicNames,'')as TopicNames,max(Score) Score,min(SourceName) SourceName       

  from(select Top (@Limit)I.Id, I.Link, I.PubDate, I.Title, I.[Description], Tag.Name, ISNULL(dbo.[GetSignalNames](I.Id),'') as [TopicNames],0.3 as Score, RS.Name as [SourceName] from dbo.RssFeedItem I inner join dbo.RssFeedItemTag T on (T.RssFeedItemId =
 I.Id)  inner join Tag on t.tagid = Tag.id inner join dbo.RssFeed F on (F.Id = I.RssFeedId) inner join dbo.RssSource RS on (RS.Id = F.RssSourceId)      

  --inner join Topic Tp on Tp.RssFeedItemId = I.Id      

    --LEFT OUTER join Topic Tp on Tp.RssFeedItemId = I.Id      

inner join dbo.RssFeedItemIndustry RFII on RFII.RssFeedItemId = I.Id where T.TagId in (select TagId from MagazineTag where MagazineId = @MagazineId) and RFII.IndustryId = @IndustryId and T.ConfidenceScore > 0.7 and RS.rssTypeID <> 3       

  --and (year(I.PubDate)=year(getdate()) or year(I.PubDate)=year(getdate())-1 )        

 ORDER BY I.id DESC      

 ) R      

 group by Link,Pubdate,Title,Description, TopicNames, name order by Score desc OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;      

 End      

  

END      

  

      

  

      

  

      

  

      

  

      

  

      

  

      

  

      

  

      

  

      

  

      

      

      

      

      

      

      
