/****** Object:  View [dbo].[TechnoGraph]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[TechnoGraph]
as
select   a.Keyword,count(a.keyword) as clients_count from Technographics a
    left join  Tag t on a.tagid = t.Id    left join TechStackTechnology b  on t.Id = b.TagId
    left join TechStackSubCategory c on b.StackSubCategoryId = c.Id   
     where t.TagTypeId = 25 
	 and len(a.keyword)> 2
	  group by keyword
	 --<!--and MONTH(a.insertedDate) = MONTH(GETDATE())-8  AND YEAR(a.insertedDate) = YEAR(GETDATE()-1)-->
	 
