/****** Object:  View [dbo].[v_organization_names]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view v_organization_names as 
select id, name, 'Name' as data_column from Organization
where name is not null
union
select id, name2 collate SQL_Latin1_General_CP1_CI_AS, 'Name2' as data_column from Organization 
where name2 is not null
union
select id, FullName collate SQL_Latin1_General_CP1_CI_AS,'FullName' as data_column  from Organization 
where FullName is not null
