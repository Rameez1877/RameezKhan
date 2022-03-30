/****** Object:  View [dbo].[keyCombination3]    Committed by VersionSQL https://www.versionsql.com ******/

create view keyCombination3 
as select m.keyword + ',' + d.keyword as keywords from McDecisionmaker m,
 DecisionMakerList d where len(m.Keyword)>3 and
  (m.keyword not in (select keyword from McDecisionmaker where 
  (Keyword like ('%chief%')
  or keyword like ('%manager%')
  or keyword like ('%head%')
  or keyword like ('%developer%')
  or keyword like ('%engineerr%')
  or keyword like ('%specialist%')
  or keyword like ('%marketer%')
 )))
 and m.IsActive = 1
 and d.SeniorityLevel in ('director', 'c-level')
 and d.Keyword not in ('CEO','chairman','founder', 'co-founder', 'Fundador','Co Fundador','Co fondateur')
