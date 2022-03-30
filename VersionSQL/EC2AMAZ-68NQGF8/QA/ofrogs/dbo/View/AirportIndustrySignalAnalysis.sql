/****** Object:  View [dbo].[AirportIndustrySignalAnalysis]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AirportIndustrySignalAnalysis]

AS



	  select   CAST(ROW_NUMBER() OVER (ORDER BY L.id) - 1 AS INT) AS id, RF.id as 'RssfeeditemId',RF.title,RF.News,t.id as 'Tagid' ,T.name as 'TagName',L.name as 'DecisionmakerName',L.url,L.emailid,RF.PubDate
from  dbo.linkedindata L, dbo.RssFeedItem as RF ,    dbo.RssFeedItemtag as RFT,    dbo.RssFeedItemindustry as RFTI ,   dbo.IndustryTag As IT,  dbo.Tag AS T 
 where  T .TagTypeId = 1 and RF.id=RFT.RssFeedItemid	 and RFTI.RssFeedItemid=RFT.RssFeedItemid 
	  and RFTI.industryid= IT.industryid  	   and IT.tagid = T.id	 and T.id = L.tagid  
	   and IT.industryid=72 and RFT.tagid=T.id and RFT.confidencescore >0.8 and L.decisionmaker='DecisionMaker' and  CONVERT(date,PubDate) >= '2018-01-01' and L.name NOT Like '%?%'
