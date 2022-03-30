/****** Object:  View [dbo].[V_TargetPersonaFilterEmpCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_TargetPersonaFilterEmpCount]
as
SELECT 
EmployeeCount as ID,
nooforganizations,
EmployeeCount + ' ' + '('+ ltrim(str(nooforganizations))+ ')' as Name,
'All (' +ltrim(str(
sum(nooforganizations) over()
)) + ')' as AllOrganizations
FROM TargetPersonaFilterEmployeeCount
