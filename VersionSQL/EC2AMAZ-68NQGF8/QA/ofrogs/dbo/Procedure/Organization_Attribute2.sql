/****** Object:  Procedure [dbo].[Organization_Attribute2]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[Organization_Attribute2]
@industryid int,@appuserid int

AS
BEGIN
	SET NOCOUNT ON;
DECLARE @columns varchar(max)
DECLARE @convert varchar(max)

SELECT
@columns = STUFF((SELECT DISTINCT
'],[' + AttributeName FROM attribute a,industryattribute att WHERE  att.attributeid=a.attributeid and att.industryid=@industryid FOR xml PATH ('')), 1, 2, '') + ']'
SET @convert =
'select * from (SELECT TOP 1000 att.industryid,i.name as Industry ,a.attributeName,at.organizationid,o.name,at.attributevalue,od.domainname,t.id as tagid,count(decisionmaker) as DecisionmakerCount
FROM  industry i,organization o,tag t ,ofuser.customertargetlist ct, linkedindata ld ,attribute a ,organizationattribute at,organizationdomain od ,industryattribute att
WHERE i.id=att.industryid  and  o.id=at.organizationid and o.id=t.organizationid and  t.id=ld.tagid and a.attributeid=at.attributeid 
and at.organizationid=od.organizationid and att.attributeid=a.attributeid  and ct.tagid=t.id and ct.appuserid=78
and att.industryid =' + cast(@industryid as varchar) + ' and ld.decisionmaker=''DecisionMaker'' and ld.userid=78
group by t.id,at.organizationid,att.industryid,i.name,a.attributeName,o.name,at.attributevalue,od.domainname
) SubQuery
pivot(min(attributevalue) for AttributeName
in (' + @columns + ')) as pivottable'
EXECUTE (@convert)
   
End	
