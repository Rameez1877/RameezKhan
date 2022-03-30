/****** Object:  View [dbo].[V_WebsiteSegment]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[V_WebsiteSegment] as
select segment from WebsitenavigationSegment
group by segment 
