/****** Object:  View [dbo].[MktListDCIList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[MktListDCIList]
AS
select a.id,  b.name as marketinglist_name,b.decisionmakerlistname as marketinglist_DmName,a.functionality,
 a.targetcustomer,a.name, a.designation, a.summary, a.url, a.city,a.country, 
		a.decisionmaker, a.lastupdateddate, a.domainname, a.emailid,a.phonenumber,
		 a.score,a.firstname,a.lastname,a.organization,a.state,a.linkedin_country,
		a.suggested_domainname, a.goldcustomer,a.firstsuggested_domainname,a.emailverificationstatus,a.industryid,a.userid,
		a.emailgeneratedby,CASE WHEN a.gender ='F' THEN Cast (0 as bit)  ELSE Cast (1 as bit) END AS gendertype,gender
from linkedindata a left join mcdecisionmakerlist b on a.id=b.decisionmakerid
where b.name is not NULL and userid>0 and industryid>0 and b.isactive=1 and a.isactive=1
