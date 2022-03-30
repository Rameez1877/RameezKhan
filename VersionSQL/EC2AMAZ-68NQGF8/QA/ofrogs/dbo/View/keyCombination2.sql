/****** Object:  View [dbo].[keyCombination2]    Committed by VersionSQL https://www.versionsql.com ******/

create view keyCombination2 
as select m.keyword + ',' + d.keyword as keywords from McDecisionmaker m,
 DecisionMakerList d where m.Keyword is not null and d.SeniorityLevel in ('director', 'c-level') and m.IsActive = 1
 and len(m.keyword)>0
