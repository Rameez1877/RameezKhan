/****** Object:  View [dbo].[Companycountbyindustries]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[Companycountbyindustries]
as
select  top 999999999 i.name,o.industryid,count(*) as 'Totalcompanies'
 from industry i join organization o on i.id=o.industryid
 where industryid<=20
 group by i.name,o.industryid
 order by Totalcompanies desc
