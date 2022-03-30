/****** Object:  View [dbo].[V_WebsiteNavigationSegment]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[V_WebsiteNavigationSegment] as 
select wns.*, WIKC.Name as WebsiteIntentKeywordCategoryName from WebsiteNavigationSegment WNS, WebsiteIntentKeywordCategory WIKC
where wns.WebsiteIntentKeywordCategoryID = WIKC.ID
