/****** Object:  View [dbo].[v_li_decisionmaker]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view v_li_decisionmaker as 
select t.organizationid, count(*) DecisionMakerCount from linkedindata li, tag t
where li.tagid=t.id
and li.decisionmaker='DecisionMaker'
group by t.organizationid
