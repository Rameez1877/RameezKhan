/****** Object:  View [dbo].[V_SeniorityLevel]    Committed by VersionSQL https://www.versionsql.com ******/

Create View V_SeniorityLevel
as
select distinct senioritylevel From DecisionMakerList where SeniorityLevel is not null
