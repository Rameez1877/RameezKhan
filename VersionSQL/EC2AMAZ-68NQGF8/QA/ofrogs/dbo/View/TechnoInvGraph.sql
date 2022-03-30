/****** Object:  View [dbo].[TechnoInvGraph]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[TechnoInvGraph]
as
--select companyname, count(distinct keyword) as keywordcount from Technographics
--where inserteddate < DATEADD(month, -6, GETDATE())  
--group by companyname

select companyname, count(distinct keyword) as keywordcount from Technographics t1
join TechStacktechnology t2 on t1.tagid = t2.tagid
join TechStackSubCategory t3 on t3.id = t2.StackSubCategoryId
join TechStackCategory t4 on t4.ID = t3.StackCategoryId
group by t1.companyname
