/****** Object:  Procedure [dbo].[GetAirportNews]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[GetAirportNews]                                
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
 select Id,                                
 -- rfi.title, PUBDATE, description,                                 
 case when title like '%airport%' and (          
title like '%digital boardroom%' or          
title like '%artificial intelligence%' or          
title like '%IOT data integration%'or          
title like '%data integration%'or          
title like '%baggage handl%' or  --baggage handling        
title like '%operation%'or          
title like '%business intelligence%'or          
title like '%data governance%'or          
title like '%parking%'or          
title like '%concession%'or          
title like '%delay%'or          
title like '%congestion%'or          
title like '%problem%'or          
title like '%innovation%'or          
title like '%maintenance%'or          
title like '%business%'or          
title like '%development%'or          
title like '%retail%'or          
title like '%commerce%'or          
title like '%maintenance%' or          
title like '%energy%' or        
title like '%groud handl%' or-- ground handling        
title like '%human resource%' or        
title like '%employee strike%'or        
title like '%employee engagement%'or        
title like '%leadership training%' or        
title like '%passenger survey%'or        
title like '%retail%'or        
title like '%airline market%' or--    airline marketing        
title like '%Asset%' or --Asset management        
--title like '%Energy Sav%' or --Energy Saving        
--title like '%Energy Manag%' or --Energy Management        
title like '%passenger experience%' or         
title like '%Analytic%' or         
title like '%business intelligence%' or         
title like '%Operations Analytic%' or         
title like '%on-time performance%' or         
title like '%on time performance%' or         
title like '%Terminal %' or         
title like '%Airside%' or         
title like '%Wait time%' or         
title like '%Leaderboard%' or         
title like '%Safety%' or         
title like '%Fire Management%' or         
title like '%resource utilization%' or         
title like '%resource%' or         
title like '%terminal activit%' or         
title like '%traffic volume%' or         
title like '%flight number%' or         
title like '%airport business%' or         
title like '%flights handl%' or         
title like '%energy%' or      
title like '%aircraft%' or         
title like '%parking%' or         
title like '%check-in%' or         
title like '%gate%' or         
title like '%baggage%' or         
title like '%Cargo volume%' or      
title like '%sustaining capex%' or       
title like '%CAPEX Analytic%' or       
title like '%service quality%' or       
--title like '%management%' or --(Project management,Assets Management,management)      
title like '%benchmark%' or --(benchmarking)      
title like '%Contract%' or       
title like '%Portfolio%' or       
title like '%Procure %' or       
title like '%asset%' or        
title like '%profit%' or       
title like '%revenue%' or       
title like '%Hedg%' or       
title like '%optimiz%' or       
title like '%retail%' or       
title like '%Commercial%' or       
title like '%Parking%' or       
title like '%Advertise%' or      
title like '%gate cost%'      
)         
then 745          
else 968          
end           
from rssfeeditem           
where link not like '%indeed%' and link not like '%jobs%'          
and convert(date, pubdate) = convert(date, getdate()-2)        
          
 Insert into categoryScore (RssFeedItemID, CategoryID, Score)                                
  select LN.RssFeedItemId, C.ID, 1 from @LabelNews LN, Category C                                 
  where LN.labelid = C.labelid                                
End 
