/****** Object:  View [dbo].[Keywordlist_linkedin1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view  [dbo].[Keywordlist_linkedin1]
as
 select top 100 CAST(ROW_NUMBER() OVER (ORDER BY b.id) - 1 AS INT) AS id, a.country,a.id as groupid,
CONCAT(a.firstname,' ',a.lastname, ',', a.Company , ' ', b.CountryUrl) as keyword , 944 as listid,
c.username as apikey,'Keyword' as KeywordType, a.isActive as isActive
from GrayMatterCRmDataNonAAPLus a , country b,appuser c
 where   a.country=b.name and c.id=137 and b.CountryUrl!='' and a.isactive=0
