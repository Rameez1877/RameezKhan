/****** Object:  View [dbo].[targetAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE view  [dbo].targetAttribute
 as
 select distinct AttributeName, CAST(ROW_NUMBER() OVER (ORDER BY o.id) - 1 AS INT) AS id, Name,  AttributeValue,oa.organizationid,oa.attributeid from OrganizationAttribute oa
join attribute a on oa.attributeid = a.AttributeId
join organization o on oa.OrganizationID=o.id
