/****** Object:  View [dbo].[V_SalesgigStartupSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE View Salesgig_SampleData as 
With CTE AS(
Select t.OrganizationId, count(distinct url) as NoOfJobs from IndeedJobPost i, tag t
where i.TagIdOrganization = t.id and i.InsertedDate >= '2019-09-12'
group by t.OrganizationId
)
Select O.Name as Organization, WebsiteUrl, EmployeeCount, I.name as Industry, c.name as Country, cte.NoOfJobs
from organization o
join Industry I on I.id = o.IndustryId
join Country c on c.ID = o.CountryId
left outer join CTE on cte.OrganizationId = o.id
where DataSource = 'Angel.co'
