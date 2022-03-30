/****** Object:  View [dbo].[V_TargetPersonaFilterRevenue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_TargetPersonaFilterRevenue]
as
SELECT 
Revenue as ID,
nooforganizations,
Revenue + ' ' + '('+ ltrim(str(nooforganizations))+ ')' as Name,
'All (' +ltrim(str(
sum(nooforganizations) over()
)) + ')' as AllOrganizations
FROM TargetPersonaFilterRevenue
