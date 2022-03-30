/****** Object:  View [dbo].[awardsview]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[awardsview] as 
select Excellence_in_Program_Area as Awards, count(*) countAwards from awards where Excellence_in_Program_Area is not null group by Excellence_in_Program_Area 
