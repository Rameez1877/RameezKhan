/****** Object:  View [dbo].[Companycountbyattributes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[Companycountbyattributes]
as
select top 999999999 a.AttributeName,oa.attributeid,count(*) as totalcompanies,ia.industryid
 from  attribute a join  OrganizationAttribute oa  on  a.AttributeId=oa.AttributeID
 join industryattribute  ia on ia.attributeid=a.AttributeId
 group by ia.industryid, a.AttributeName,oa.attributeid
 order by totalcompanies desc
