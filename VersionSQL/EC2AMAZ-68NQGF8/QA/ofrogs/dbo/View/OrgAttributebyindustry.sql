/****** Object:  View [dbo].[OrgAttributebyindustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[OrgAttributebyindustry]
as
SELECT top 999999
    a.AttributeId, AttributeName, att.industryid FROM attribute a,industryattribute att
 WHERE  att.attributeid=a.attributeid 
 order by att.industryid
 
