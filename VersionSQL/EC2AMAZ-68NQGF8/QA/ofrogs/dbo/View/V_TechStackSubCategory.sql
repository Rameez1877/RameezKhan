/****** Object:  View [dbo].[V_TechStackSubCategory]    Committed by VersionSQL https://www.versionsql.com ******/

create view V_TechStackSubCategory
as
select id,StackType as name from TechStackSubCategory
where id in(2,5,6,46,1,98,16,12,8,9,760,3,4,17,19,207,603,10,13,196,140,72,208,203,617,365,372,294,200)
