/****** Object:  View [dbo].[keyCombination]    Committed by VersionSQL https://www.versionsql.com ******/

create view keyCombination 
as select m.keyword + ',' + d.keyword as keywords from McDecisionmaker m, DecisionMakerList d where m.Keyword is not null and d.Keyword is not null and len(m.keyword)>0
and len(d.keyword)>0
