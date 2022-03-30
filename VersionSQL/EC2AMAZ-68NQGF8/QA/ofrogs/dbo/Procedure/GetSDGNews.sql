/****** Object:  Procedure [dbo].[GetSDGNews]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[GetSDGNews]                                              
--@RssFeedItemId int                                              
As                                              
Begin                                              
 --declare @Keyword varchar(50);                                              
 --declare @id int;                                              
 --declare @mydate date;                                              
                                              
  SET NOCOUNT ON;                                              
   DECLARE @LabelNews TABLE                                               
 (                                              
  rssfeedItemID int,                                              
  LabelId int                                              
 )                                              
                                              
 insert into @LabelNews (rssfeedItemID, LabelId)                                              
 select rfi.Id,                                              
 -- rfi.title, PUBDATE, description,                                               
 case                                              
 when rfi.title like '%SDG%'          
  or rfi.title like '%sustainable development%'            
  or rfi.title like '%sustainable development goal%' then 143                                              
 /*SDG6 - clean water and sanitation*/                                               
  when rfi.title like '%malnutrition%' or                                              
rfi.title like '%latrine%' or                                              
rfi.title like '%sanitation%' or                                              
rfi.title like '%hygiene dental%' or                     
rfi.title like '%hygiene behavior%' or                     
rfi.title like '%hygiene rule%' or                     
rfi.title like '%rule hygiene%' or                                                                                                
rfi.title like '%diarrhoeal%' or                                              
rfi.title like '%recycling%' or                                              
---rfi.title like '%toilet %' or                                              
rfi.title like '%drinking water%' or                                              
rfi.title like '%clean water%' or                                              
rfi.title like '%defecate%' or                                              
rfi.title like '%water contamination%' or                                              
rfi.title like '%water scarcity%' or                                              
rfi.title like '%waste water%' or                                              
rfi.title like '%water source%' or                                              
rfi.title like '%toilet day%' or                                              
rfi.title like '%water resource%' or                                              
rfi.title like '%water stress%' or                                              
rfi.title like '%water supply%' or                                              
--rfi.title like '%handwash%' or                                              
rfi.title like '%wastewater%' or                                              
rfi.title like '%water cycle%' or                                              
rfi.title like '%groundwater%' or                                              
rfi.title like '%water table%' or                                              
rfi.title like '%water management%' or                                              
rfi.title like '%wastewater management%' or                                              
rfi.title like '%wastewater%' or                                              
rfi.title like '%water cycle%' or                                              
rfi.title like '%groundwater%' or                                              
rfi.title like '%water table%' or                            
rfi.title like '%SDG6%' or              
rfi.title like '%SDG 6%' or                           
rfi.title like '%water management%' or                                              
rfi.title like '%wastewater management%'  then 103                                              
/*SDG13 - climate action*/                                      
  when rfi.title like '%climate change%' or           
  rfi.title like '%green house%' or           
  rfi.title like '%biodiversity%' or           
  rfi.title like '%afforestation%' or                                              
      rfi.title like '%carbon emission%' or           
   rfi.title like '%Chlorofluorocarbon%' or           
--   rfi.title like '%Clean Energy%' or           
   rfi.title like '%Climate Control%' or                        
      rfi.title like '%desertification%' or                                              
--rfi.title like '%GHG%' or                                      
--rfi.title like '%climate%' or                                              
rfi.title like '%Global Warming%' or                                           
rfi.title like '%Green Cover%' or                                              
rfi.title like '%greenhouse emission%' or                                              
rfi.title like '%greenhouse gas%' or                                              
rfi.title like '%greenpeace%' or                                              
rfi.title like '%PARIS AGREEMENT%' or                                              
--rfi.title like '%flood%' or                                              
rfi.title like '%SDG13%' or                        
rfi.title like '%SDG 13%' or                                
rfi.title like '%ozone layer%' or                                              
rfi.title like '%polluted Environment%' or                                   
rfi.title like '%tsunami%' then 135                                              
  /*SDG 1 - no poverty*/                                              
  when rfi.title like '%poverty%' or rfi.title like'%basic amenities %' or                                              
rfi.title like'%below poverty%' or                                              
rfi.title like'%cash transfer%' or                                              
rfi.title like'%child labour%' or                                              
rfi.title like'%child mortality%'or                                              
rfi.title like'%developing country%'or                                              
rfi.title like'%end poverty%'or                                              
rfi.title like'%eradicate poverty%'or                                              
rfi.title like'%extreme poverty%'or                                              
rfi.title like'%farmer suicide%'or                                              
rfi.title like'%no poverty%'or                                              
rfi.title like'%Poverty alleviation%'or                                              
rfi.title like'%poverty eradication%'or                                              
rfi.title like'%poverty line%'or                                              
rfi.title like'%poverty reduction%'or            rfi.title like'%poverty score%'or                                              
rfi.title like'%rural development%'or                                              
rfi.title like'%SDG 1%'or                              
rfi.title like'%SDG1%'or                             
rfi.title like'%social discrimination%'or                                          
rfi.title like'%social injustice%'or                                              
rfi.title like'%third world%'or                                              
rfi.title like'%uneven progress%'or                                           
rfi.title like'%urban poverty%'or                                              
rfi.title like'%Youth Employment%' then 1    
 /*SDG4 - Education*/                                              
when rfi.title like '%education%' or rfi.title like '%literacy%' or rfi.title like '%adult education%' or                     
rfi.title like '%disadvantaged children%' or                                              
rfi.title like '%basic amenities%' or                                              
rfi.title like '%social discrimination%' or                                              
rfi.title like '%secondary education%' or                                              
rfi.title like '%primary education%' or                                              
rfi.title like '%quality education%' or                                              
rfi.title like '%child marriage%' or                                              
rfi.title like '%Secondary School%' or                                              
rfi.title like '%Primary School%' or                                              
rfi.title like '%underpriviledged children%' or                                              
rfi.title like '%socio economic change%' or                                              
rfi.title like '%social impact%' or                                              
rfi.title like '%adult education%' or                                              
rfi.title like '%youth education%' or                                              
rfi.title like '%nursery school%' or                                              
rfi.title like '%kindergarten%' or                       
rfi.title like '%education policy%' or                                              
rfi.title like '%education system%' or                                              
rfi.title like '%education fund%' or                                              
rfi.title like '%disadvantaged children%' or                                              
rfi.title like '%vocational training%' or                                              
rfi.title like '%skilled labour%' or                                              
rfi.title like '%enrolment rate%' or                                              
rfi.title like '%Rural Education%' or                                              
rfi.title like '%SDG 4%' or                                 
rfi.title like '%SDG4%' or                            
rfi.title like '%Childhood education%' or                                              
rfi.title like '%underpriviledged children%' then 69            
                                              
/*SDG2 - zero hunger*/                                              
when rfi.title like '%food assistance%' or                                              
rfi.title like '%food availability%' or                                              
rfi.title like '%food production%' or                                              
rfi.title like '%food program%' or                                              
rfi.title like '%food security%' or                                 
rfi.title like '%food supply%' or                                              
--rfi.title like '%food safety%' or            
rfi.title like '%Food malnutrition%' or            
rfi.title like '%famine%' or                                              
--rfi.title like '%FAO%' or                                              
rfi.title like '%fight hunger%' or                                              
rfi.title like '%end hunger%' or                                              
rfi.title like '%eliminate hunger%' or                                              
rfi.title like '%agriculture%' or                                              
rfi.title like '%agriculture organization%' or                                              
rfi.title like '%SDG 2%' or                      rfi.title like '%malnutrition%' or                                              
rfi.title like '%humanitarian%' or                                              
rfi.title like '%zero hunger%' or              
rfi.title like '%undernourish%' or                                              
rfi.title like '%subsidy%' then 735                                              
/*SDG 10 Reduced Inequalities*/                                              
when rfi.title like '%Reduce Inequality%' or                                              
rfi.title like '%SDG10%' or                             
rfi.title like '%SDG 10%' or                                            
rfi.title like '%gender inequality%' then 682                                  
/*SDG4 - Good Health and well being*/              
when rfi.title like '%substance abuse%' or                                              
rfi.title like '%substance use disorder%' or                                              
rfi.title like '%Tobacco Control%' or                                              
rfi.title like '%undernutrition%' or            
rfi.title like '%tuberculosis%' or                                              
rfi.title like '%universal access%' or                                              
rfi.title like '%tropical disease%' or                                              
rfi.title like '%vaccine%' or                                              
rfi.title like '%water borne disease%' or                                          
rfi.title like '%health care%' or                                              
rfi.title like '%health hazard%' or                                              
rfi.title like '%health risk%' or                                              
rfi.title like '%Health service%' or                                              
rfi.title like '%Immunization%' or                                              
rfi.title like '%infant mortality%' or                                              
rfi.title like '%malaria%' or                                              
--rfi.title like '%malnourish%' or                                              
--rfi.title like '%malnutrition%' or                                              
rfi.title like '%Maternal Health%' or                                              
rfi.title like '%maternal mortality%' or                                              
rfi.title like '%Medical equipment%' or                                              
rfi.title like '%Mental health%' or                                              
rfi.title like '%mortality rate%' or                                              
rfi.title like '%Neonatal Health%' or                                              
rfi.title like '%SDG 3%' or                            
rfi.title like '%SDG3%' or                                  
rfi.title like '%social discrimination%' or                                              
rfi.title like '%premature death%' or                                             
rfi.title like '%preventable death%' or                                              
rfi.title like '%Primary care%' or                                              
rfi.title like '%polio drops%' or                                              
rfi.title like '%Public health%' or                                              
rfi.title like '%respiratory disorder%' or                                              
rfi.title like '%respiratory infection%' or                                              
rfi.title like '%air pollution%' or                                              
rfi.title like '%affordable medicine%' or                                              
rfi.title like '%alcohol addiction%' or                                              
rfi.title like '%child mortality%' or                                  
rfi.title like '%cardiovascular disease%' or                                              
rfi.title like '%Child care%' or                                              
rfi.title like '%child death%' or                                            
rfi.title like '%cancer%' or                                              
rfi.title like '%drug abuse%' or                                          
rfi.title like '%dengue%' or                                              
rfi.title like '%contraceptive use%' or                                              
rfi.title like '%fighting AIDS%' or                                              
rfi.title like '%fighting HIV%' or                                            
rfi.title like '%epedemic%' or                                              
rfi.title like '%good health%' then 33                                              
-- 'SDG 3 Good Health and well being'                                              
/*ECONOMIC GROWTH*/                                              
when rfi.title like '%gross domestic product%' or                                              
rfi.title like '%financial exclusion%' or                           
rfi.title like '%financial inclusion%' or                                    
rfi.title like '%generate employment%' or                                    
rfi.title like '%entrepreneur%' or                                              
rfi.title like '%economic activities%' or                                              
rfi.title like '%job create%' or         
rfi.title like '%SDG8%' or                                
rfi.title like '%SDG 8%' or                              
rfi.title like '%labour rights%' or                                              
rfi.title like '%inclusive growth%' or                                              
rfi.title like '%human trafficking%' then 681                                              
--'SDG 8 economic growth'                                              
/*Industry Innovation and Infrastructure*/                                       
when rfi.title like '%income inequality%' or                                              
rfi.title like '%inclusion%' or                                              
rfi.title like '%imbalance%' or                                              
rfi.title like '%infrastructure %' or                                
rfi.title like '%Investment%' or                                              
rfi.title like '%small enterprise%' or                                              
rfi.title like '%small scale%' or                                                                  
rfi.title like '%Rising inequality%' or                                              
rfi.title like '%employment%' or                                              
rfi.title like '%empower%' or                                              
rfi.title like '%equal opportunity%' or                                              
rfi.title like '%encourage innovation%' or                                              
rfi.title like '%encourage research%' or                                              
rfi.title like '%foster innovation%' or                                              
rfi.title like '%economic development%' or                                              
rfi.title like '%SDG 9%' or                    
rfi.title like '%SDG9%' or                  
rfi.title like '%industrial development%' or                                              
rfi.title like '%industrialization%' or                                              
rfi.title like '%upgrade infrastructure%' or                                              
rfi.title like '%technology development%' or                                              
rfi.title like '%sustainable development%' then 736                                              
--'SDG 9 Industry Innovation and Infrastructure'                              
                                             
/*Safe and Sustainable cities*/                                              
when rfi.title like '%safety record%' or                                              
rfi.title like '%SDG11%' or                   
rfi.title like '%SDG 11%' or                                           
rfi.title like '%sustainable city%' then 683                                              
--'SDG11 Safe and Sustainable cities'                                              
/*Sustainable production and consumption*/                                              
when rfi.title like '%sustainable consumption%' or                                              
rfi.title like '%sustainable production%' or                                              
rfi.title like '%SDG 12%' or                                              
rfi.title like '%reduce waste%' or                   
rfi.title like '%reduce food loss%' or                                          
rfi.title like '%material footprint%' or                                              
rfi.title like '%hazardous chemical%' or                                              
rfi.title like '%hazardous waste%' or                                              
rfi.title like '%food loss%' or                                              
rfi.title like '%consumption%' then 684                                              
--'SDG12 Sustainable production and consumption'                                              
/*SDG14 - Conservation of Marine Resources*/                                              
when rfi.title like '%unregulated fishing%' or                                              
rfi.title like '%SDG 14%' or                                              
rfi.title like '%regulated fishing%' or                                             
rfi.title like '%marine acidity%' or            
rfi.title like '%marine economy%' or                                            
rfi.title like '%marine life%' or                                       
rfi.title like '%marine pollution%' or                                              
rfi.title like '%ocean acidification%' or                                              
rfi.title like '%overfish%' or                                              
rfi.title like '%overfishing%' or                                              
rfi.title like '%ph level%' or                                              
rfi.title like '%plastic debris%' or                                     
rfi.title like '%hydrological systems%' or                                              
rfi.title like '%illegal fishing%' or                                
rfi.title like '%fish stock%' or                                              
rfi.title like '%fishery%' or                                              
rfi.title like '%fishing practice%' or                                              
rfi.title like '%aquatic animal%' or                                              
rfi.title like '%aquatic plant%' or                             
rfi.title like '%desilt%' or                                              
rfi.title like '%coastal communities%' or                                              
rfi.title like '%coastal community%' or                                              
rfi.title like '%coastal ecosystem%' then 662                                         
                                   
/*Conservation of ecosystem*/                                              
when rfi.title like '%desertification%' or                                              
rfi.title like '%wetland%' or                                              
rfi.title like '%biodiversity%' or                                              
rfi.title like '%Forest Management%' or                                              
rfi.title like '%afforestation%' or                                              
--rfi.title like '%combat%' or                                              
--rfi.title like '%poaching%' or                                              
--rfi.title like '%ecosystem%' or                       
rfi.title like '%extinct species%' or                                        
rfi.title like '%extinction risk%' or                                              
rfi.title like '%extinction %' or                                              
rfi.title like '%conservation%' or      
rfi.title like '%restoration%' or                                              
rfi.title like '%Green Cover%' or                                              
rfi.title like '%illicit wildlife%' or                                              
rfi.title like '%alien species%' or                                              
rfi.title like '%Preserve diverse%' or                                              
rfi.title like '%prevent extinction%' or                                              
rfi.title like '%protect species%' or                 
rfi.title like '%protected area%' or                                              
--rfi.title like '%restore%' or                                              
rfi.title like '%deforestation%' or                                              
rfi.title like '%sustainable management%' or                                              
rfi.title like '%sustainable use%' or                                              
rfi.title like '%threatened species%' or                    
rfi.title like '%wildlife%' or                                              
rfi.title like '%trafficking%' or                 
rfi.title like '%elephant poach%' or               
rfi.title like '%wildlife poach%' or                                            
rfi.title like '%Forest%' or                                              
rfi.title like '%biodiversity%' or                                              
--rfi.title like '%mountain%' or                                              
rfi.title like '%freshwater%' or                                              
rfi.title like '%terrestrial%' or                                              
rfi.title like '%ecosystem%' or                                    
--rfi.title like '%combat%' or                                              
rfi.title like '%deforestation%' or                                              
--rfi.title like '%conservation%' or                                              
rfi.title like '%desertification%' or                                              
rfi.title like '%ecosystem%' or                                              
rfi.title like '%alien species%' or                                              
rfi.title like '%afforestation%' or                                              
--rfi.title like '%biodiversity%' or                                              
--rfi.title like '%ecosystem%' or                                              
--rfi.title like '%mountain%' or                                              
rfi.title like '%terrestrial%' or                                              
rfi.title like '%biodiversity%' or                                             
rfi.title like '%extinct species%' or                                              
--rfi.title like '%extinction%' or                                              
rfi.title like '%extinction risk%' or                           
rfi.title like '%Green Cover%' or                                              
rfi.title like '%Forest Management%' or                                              
rfi.title like '%freshwater%' or                                              
rfi.title like '%Forest%' or                                              
rfi.title like '%illicit wildlife%' or                                              
rfi.title like '%poaching%' or                                              
rfi.title like '%restoration%' or                                              
--rfi.title like '%restore%' or                                              
rfi.title like '%protect species%' or                                              
rfi.title like '%protected area%' or                                              
rfi.title like '%Preserve diverse%' or                                          
rfi.title like '%prevent extinction%' or                                              
rfi.title like '%SDG 15%' or                                              
rfi.title like '%trafficking%' or                                        
rfi.title like '%sustainable use%' or                                              
rfi.title like '%sustainable management%' or                                              
rfi.title like '%threatened species%' or                                             
rfi.title like '%wetland%' or                                              
rfi.title like '%wildlife%' or                                              
rfi.title like '%UNFF%' or                                              
rfi.title like '%United Nations Forum on Forests%' or                                              
rfi.title like '%Forest Management%' then 679                           
/*SDG16Peace Justice and Strong Instituion*/                                              
when rfi.title like '%exploit%' or                                              
rfi.title like '%security%' or                                              
rfi.title like '%Inclusive societies%' or                                              
rfi.title like '%strong institution%' or                                              
rfi.title like '%justice%' or                                              
--rfi.title like '%Peace%' or                                              
--rfi.title like '%human right%' or                                              
--rfi.title like '%justice%' or                            
rfi.title like '%ethnic group%' or                                              
rfi.title like '%racial abuse%' or                                              
--rfi.title like '%information%' or                                              
rfi.title like '%armed conflict%' or                                          
--rfi.title like '%violence%' or                                              
rfi.title like '%combat crime%' or                                              
rfi.title like '%combat terrorism%' or                                              
rfi.title like '%constitutional guarantee%' or                                              
rfi.title like '%constitutional right%' or                                   
rfi.title like '%discriminated against%' or                                              
rfi.title like '%fight against illegal%' or                                              
--rfi.title like '%freedom%' or                                              
--rfi.title like '%detention%' or                                              
rfi.title like '%human rights%' or                                              
rfi.title like '%human trafficking%' or                                             
rfi.title like '%humanitarian need%' or                                             
rfi.title like '%illicit arms%' or                                              
rfi.title like '%illicit financial flow%' or                                              
rfi.title like '%individual rights%' or                                              
--rfi.title like '%homicide%' or                          
--rfi.title like '%bribery%' or                                              
rfi.title like '%people struggle%' or                                              
rfi.title like '%physical punishment%' or                                              
rfi.title like '%policy guarantee%' or                                              
rfi.title like '%population displacement%' or                                              
rfi.title like '%prevent violence%' or                                              
rfi.title like '%prohobit discrimination%' or                                              
rfi.title like '%protect freedom%' or                                              
rfi.title like '%protect fundamental%' or                                              
rfi.title like '%psychological aggression%' or                                              
rfi.title like '%reduce bribery%' or                                              
rfi.title like '%reduce corruption%' or                                  
rfi.title like '%resolution mechanism%' or                                              
rfi.title like '%rule of law%' or                                              
rfi.title like '%Sexual violence%' or                                              
rfi.title like '%statutory right%' or                                              
--r--fi.title like '%torture%' or                                              
rfi.title like '%torture of children%' or                                              
rfi.title like '%trafficking of%' or                                              
rfi.title like '%undermine trust%' or                                              
--rfi.title like '%unsentenced %' or                                   
rfi.title like '%victims of robbery%' or                                              
rfi.title like '%violence against%' or                                              
rfi.title like '%Voting right%' or                                              
rfi.title like '%sentencing%' or                                              
rfi.title like '%SDG 16%' or             
rfi.title like '%SDG16%'             
then 651                                   
          
/*SDG17 Global Partnership*/                                              
when rfi.title like '%takes responsibility%' or                                              
rfi.title like '%social partner%' or                                              
rfi.title like '%commit%' or                                              
rfi.title like '%exchange%' or                                              
rfi.title like '%collaborate%' or                                              
rfi.title like '%partner%' or                                              
rfi.title like '%cooperate%' or            
rfi.title like '%SDG 17%' or                                                           
rfi.title like '%agreement%' or                                              
rfi.title like '%alliance%' or                                              
rfi.title like '%strengthen%' or                                              
rfi.title like '%contribute%' or                                        
rfi.title like '%SDG17%' Or                                          
rfi.title like '%promote responsible%' or                                              
rfi.title like '%promote sustainable%' then 685               
                                           
/*SDG5 Gender Equality*/                                              
when rfi.title like '%social discrimination%' or                                              
rfi.title like '%Maternal Health%' or                                              
rfi.title like '%child marriage%' or                                              
rfi.title like '%gender gap%' or                                              
rfi.title like '%inequality%' or                                              
rfi.title like '%gender inequality%' or                                              
rfi.title like '%gender equality%' or                                              
rfi.title like '%girl child%' or                                    
rfi.title like '%girl education%' or                                              
rfi.title like '%poverty reduction%' or                                              
rfi.title like '%exploit%' or                                              
rfi.title like '%domestic work%' or                                              
rfi.title like '%women empowerment%' or                                              
rfi.title like '%gender disparity%' or                                              
rfi.title like '%female infanticide%' or                                              
rfi.title like '%female foecticide%' or                                              
rfi.title like '%reproductive right%' or                                              
rfi.title like '%statutory legal age%' or                          
rfi.title like '%SDG5%' or                  
rfi.title like '%SDG 5%' or                                          
rfi.title like '%domestic violence%' or                                              
rfi.title like '%genital mutilation%' then 84            
                    
/*SDG7Affordable and Clean Energy*/                                              
when rfi.title like '%Clean Energy%' or                                              
rfi.title like '%affordable energy%' or                                              
rfi.title like '%clean fuel%' or                                              
rfi.title like '%energy access%' or                                              
rfi.title like '%energy consumption%' or                                              
rfi.title like '%renewable source%' or                                         
rfi.title like '%sustainable energy%' or                                              
rfi.title like '%energy demand%' or                                              
rfi.title like '%SDG 7%' or             
rfi.title like '%SDG7%'             
then 658                                             
else 698                                               
                                              
end                                              
label  from rssfeeditem rfi, rssFeed rf, rssSource rs                                               
  where rfi.rssfeedid = rf.id and rf.RssSourceId = rs.id                                
  and rfi.link not like '%indeed%' and  rfi.link not like '%monster%' and rfi.link not like '%google%'                        
  and convert(date,rfi.pubdate) = convert(date,getdate()-1)             
  and (rfi.title like '%food production%' or            
  rfi.title like '%food availability%' or            
  rfi.title like '%food security%' or            
  rfi.title like '%climate change%' or            
  rfi.title like '%carbon emission%' or            
  rfi.title like '%greenhouse gas%' or            
  rfi.title like '%greenhouse emission%' or            
  rfi.title like '%sustainable development goal%' or            
  rfi.title like '%Climate Control%' or            
  rfi.title like '%Global Warming%' or            
  rfi.title like '%food safety%' or            
  rfi.title like '%Clean Energy%' or            
  rfi.title like '%SDG%' or      
  rfi.title like '%eradicate poverty%' or   
  rfi.title like '%sustainable management%' or   
  rfi.title like '%Forest Management%'  or                                        
  rfi.title like '%threatened species%' or     
  rfi.title like '%extreme poverty%' or      
  rfi.title like '%poverty reduction%' or            
  rfi.title like '%sustainable development%' or            
  rfi.title like '%food loss%' or            
  rfi.title like '%sustainable energy%' or     
  rfi.title like '%financial inclusive%' or   
  rfi.title like '%human trafficking%' or                                            
  rfi.title like '%humanitarian need%' or   
  rfi.title like '%financial exclusive%' or    
  rfi.title like '%Food malnutrition%')                                           
                                              
  Insert into categoryScore (RssFeedItemID, CategoryID, Score)                                              
  select LN.RssFeedItemId, C.ID, 1 from @LabelNews LN, Category C                                               
  where LN.labelid = C.labelid                                              
End 
