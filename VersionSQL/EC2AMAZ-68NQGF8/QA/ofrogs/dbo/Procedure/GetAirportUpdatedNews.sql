/****** Object:  Procedure [dbo].[GetAirportUpdatedNews]    Committed by VersionSQL https://www.versionsql.com ******/

            
CREATE procedure [dbo].[GetAirportUpdatedNews]                                      
--@RssFeedItemId int                                      
As                                      
Begin                                   
---Written on 31st May, 2018                                    
                                      
  SET NOCOUNT ON;                                      
   DECLARE @LabelNews TABLE                                       
 (                                      
  rssfeedItemID int,                                      
  LabelId int                                      
 )                                                                
 insert into @LabelNews (rssfeedItemID, LabelId)                                      
 select rfi.Id,  ISNULL(dbo.GetLabelNames(RFI.Id),'') as LabelID                               
              
from rssfeeditem RFI            
 join rssfeed RF on rf.id = rfi.rssFeedid            
 join rsssource RS on rs.id = rf.rssSourceid            
where ((RFI.title like '%airport%' and RS.rsstypeid = 1)            
or (RS.industryid = 72 and RS.rsstypeid = 2))            
and (rfi.link not like '%indeed%' and rfi.link not like '%jobs%' and rfi.link not like '%google%')               
and convert(date, rfi.pubdate) = convert(date, getdate()-1)              
--and convert(date, pubdate) = convert(date, getdate()-2)          
--and convert(date, pubdate) = convert(date, getdate()-3)          
                
 Insert into categoryScore (RssFeedItemID, CategoryID, Score)                                      
  select LN.RssFeedItemId, C.ID, 1 from @LabelNews LN, Category C                                       
  where LN.labelid = C.labelid                                      
End 
