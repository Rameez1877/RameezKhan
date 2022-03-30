/****** Object:  View [dbo].[NewsTable]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[NewsTable]
AS
Select  CAST(ROW_NUMBER() OVER (ORDER BY id) - 1 AS INT) AS id,T.id as tagid,
T.Name COLLATE Latin1_General_CI_AI  as Name,day_Of_Week as wdays,
it.industryid as industryid
 from IndustryTag it, tag T where t.id = it.tagid and day_Of_Week IS NOT NULL 
 and t.TagTypeId= 1 

--change value based on day of week
union
select CAST(ROW_NUMBER() OVER (ORDER BY id) - 1 AS INT) AS id,tagid, 
name,day_Of_Week as wdays ,industryid from conceptword
 where  day_Of_Week  IS NOT NULL 
