/****** Object:  View [dbo].[OrgAttributedata]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[OrgAttributedata]
as
--SELECT  distinct ai.industryid,i.name as industry, at.organizationid as orgid ,o.name as orgname ,
-- t.id as tagid ,a.attributeName,at.attributevalue,od.domainname,count(l.decisionmaker) as decisionmakercount,ct.existingcustomer,ct.appuserid,l.userid,api.industryid as indusId
--FROM attribute a ,organizationattribute at,organizationdomain od ,industryattribute ai,
--linkedindata l,organization o,tag t ,industry i,ofuser.customertargetlist ct,appuserindustry api

--WHERE    a.AttributeId = at.AttributeId and  at.OrganizationID = od.OrganizationID and  
--         at.OrganizationID = o.Id and  o.Id = t.OrganizationId and  ai.industryid=i.id  and 
--		   ct.organizationid= at.OrganizationID and ct.newstagstatus=t.id and l.userid=ct.appuserid and
--		   ai.industryid=api.industryid and
--			    t.Id = l.tagid  and l.decisionmaker='DecisionMaker' 
--			group by  ai.industryid,i.name, at.organizationid  ,o.name  , t.id	,a.attributeName,at.attributevalue,od.domainname,ct.existingcustomer,ct.appuserid,l.userid,api.industryid
			
 
SELECT  a.AttributeId ,a.attributeName, LTRIM(STR(at.attributevaluenumeric)) attributevalue,od.domainname,
ai.industryid,at.organizationid
FROM attribute a ,organizationattribute at,organizationdomain od ,industryattribute ai, organization o
WHERE    a.AttributeId = at.AttributeId and  at.OrganizationID = od.OrganizationID 
and o.id= at.OrganizationID
and ai.AttributeId=a.attributeid
and o.industryid= ai.industryid
