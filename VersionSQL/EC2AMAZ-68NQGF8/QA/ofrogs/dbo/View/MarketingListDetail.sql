/****** Object:  View [dbo].[MarketingListDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[MarketingListDetail]
AS
select  a.functionality, CASE WHEN b.name IS NULL THEN 'Empty' ELSE b.name END AS name, a.linkedin_country as country,a.decisionmaker,a.userid as appuserid
from linkedindata a left join mcdecisionmakerlist b on a.id=b.decisionmakerid

group by a.functionality,b.name,a.linkedin_country,a.decisionmaker,a.userid
