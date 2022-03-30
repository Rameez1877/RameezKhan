/****** Object:  View [dbo].[V_Solutions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE View [dbo].[V_Solutions]
as
select id, name as Product
from WebsiteIntentKeywordCategory
where WebsitekeywordCategoryID in (13, 20)
