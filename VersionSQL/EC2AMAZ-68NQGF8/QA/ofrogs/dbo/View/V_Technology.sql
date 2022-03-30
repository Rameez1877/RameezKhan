/****** Object:  View [dbo].[V_Technology]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[V_Technology] as
select StackTechnologyName as Technology from TechStackTechnology
where isactive=1
