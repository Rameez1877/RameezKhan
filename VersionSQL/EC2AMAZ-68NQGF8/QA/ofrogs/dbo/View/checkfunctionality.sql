/****** Object:  View [dbo].[checkfunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[checkfunctionality]
AS
select  distinct b.name  from  ofuser.CustomerTargetList a left join tag b on a.newstagstatus=b.id 
 	where name!=''and appuserid=79
