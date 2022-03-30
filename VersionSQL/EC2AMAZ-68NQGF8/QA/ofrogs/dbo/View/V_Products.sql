/****** Object:  View [dbo].[V_Products]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE View [dbo].[V_Products]
as
select id, name as Product
from WebsiteIntentKeywordCategory
where WebsitekeywordCategoryID in (5)
