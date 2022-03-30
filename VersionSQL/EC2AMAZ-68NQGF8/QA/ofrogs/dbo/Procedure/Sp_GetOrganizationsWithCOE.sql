/****** Object:  Procedure [dbo].[Sp_GetOrganizationsWithCOE]    Committed by VersionSQL https://www.versionsql.com ******/

-- Procedure to find how many Organizations With COE

CREATE procedure [dbo].[Sp_GetOrganizationsWithCOE]
(
	@SubMarketingListWithCoe varchar(max)
)
as
begin
	
select org.id ,count(distinct(mcdl.name)) as "No of MarketingList" into #t1
from LinkedInData li,McDecisionmakerlist mcdl,tag tg,Organization org
where mcdl.DecisionMakerId = li.id and tg.Id=li.TagId and org.Id = tg.OrganizationId
and mcdl.name in (@SubMarketingListWithCoe,'Centre Of Excellence')
and tg.TagTypeId = 1 and li.TagId <> 0
group by org.id
having count(distinct(mcdl.name)) = 2
--------
SELECT distinct 
o.id as OrganizationId,
o.countryid 
FROM #t1,organization o with (nolock),country c 
--,linkedindata l with (nolock),tag t with (nolock)
WHERE o.id = #t1.id and c.id = o.countryid 
--and l.tagid = t.id and t.organizationid = o.Id

end
