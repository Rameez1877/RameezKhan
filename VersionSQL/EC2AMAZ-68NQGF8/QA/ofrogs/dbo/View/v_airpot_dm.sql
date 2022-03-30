/****** Object:  View [dbo].[v_airpot_dm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view v_airpot_dm as select liml.MarketingListName, count(*) NoOfProfile
 from linkedindataml liml, MarketingListKeyword m
where liml.MarketingListName=m.MarketingListName
and m.MainMarketingListName ='Airport'
group by  liml.MarketingListName
