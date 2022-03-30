/****** Object:  View [dbo].[DecisionmakerGraph]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[DecisionmakerGraph]
as
select distinct a.Name , count(a.Name) as Scorecount,a.mode ,b.industryid
from linkedindata b join mcdecisionmakerlist a on b.id = a.DecisionmakerId




 where  b.decisionmaker = 'DecisionMaker' and a.isactive=1
group by a.Name,a.mode,b.industryid
