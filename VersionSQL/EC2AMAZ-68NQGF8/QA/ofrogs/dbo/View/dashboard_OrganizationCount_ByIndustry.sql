/****** Object:  View [dbo].[dashboard_OrganizationCount_ByIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

  CREATE view  [dbo].dashboard_OrganizationCount_ByIndustry
  as
   SELECT COUNT(distinct o.name)as OrgCount, i.name  as Industry ,i.id as id
 from organization o left join industry i on i.id=o.industryid 
 left join industrytag it on i.id=it.industryid 
  left join tag t on t.id=it.tagid
 where i.name!='NULL' and t.tagtypeid=1
 GROUP BY  i.name,i.id
