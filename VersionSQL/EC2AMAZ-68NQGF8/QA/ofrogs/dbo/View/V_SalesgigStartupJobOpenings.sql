/****** Object:  View [dbo].[V_SalesgigStartupJobOpenings]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_SalesgigStartupJobOpenings] As
With CTE AS(Select * from jobpostexcellenceArea where len(JobTitleKeyword) > 2)
Select distinct i.id, Companyname, jobtitle, summary, location, url, SeniorityLevel, ExcellenceArea As MarketingList
From indeedjobpost i
join tag t on t.id = i.TagIdOrganization
join organization o on o.id = t.OrganizationId
left outer join CTE J on J.JobPostID = i.Id
Where i.InsertedDate >= '2019-09-12' and datasource like 'angel%'  
