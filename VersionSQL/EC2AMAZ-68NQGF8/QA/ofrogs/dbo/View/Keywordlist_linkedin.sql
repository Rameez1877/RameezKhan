/****** Object:  View [dbo].[Keywordlist_linkedin]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view  [dbo].[Keywordlist_linkedin]
as
--select top 200 a.id AS id, a.countryid,
--SELECT TOP 100 PERCENT a.id AS id, a.countryid,

SELECT TOP 9999999999  a.id AS id, a.countryid,
--select  a.id AS id, a.countryid,
a.SearchKeyword as keyword ,CONCAT(a.SearchKeyword, ' ', b.CountryUrl) as keyword1,a.marketinglist as listid,mdm.name as listname,c.username as apikey,a.kywdtype as KeywordType,a.appPriority,a.appBatch
from linkedinapi a  , country b,appuser c,mcdecisionmaker mdm 
 where  a.isactive=1   and a.countryid=b.id and a.appuserid=c.id and b.CountryUrl!='' and mdm.id=a.marketinglist 
 order by a.appPriority ,a.appBatch ,a.SearchKeyword 
 
