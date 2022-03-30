/****** Object:  View [dbo].[V_StackTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

create view  [dbo].[V_StackTechnology]
(TagId,
StackTechnology)
as 
--select t2.TagID, T2.StackTechnology from TechStackSubCategory t1, TechStackTechnology t2
--where t1.stackcategoryid=3
--and t1.id = t2.StackSubCategoryID
select t2.TagID, T2.StackTechnology from  TechStackTechnology t2
where t2.stacksubcategoryid = 9
