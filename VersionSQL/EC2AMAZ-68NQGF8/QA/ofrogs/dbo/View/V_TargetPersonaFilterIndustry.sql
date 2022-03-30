/****** Object:  View [dbo].[V_TargetPersonaFilterIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_TargetPersonaFilterIndustry]
as
SELECT 
IndustryId as ID,
IndustryName,
IndustryGroup,
IndustryGroupId,
nooforganizations,
IndustryName + '       ' + '('+ ltrim(str(nooforganizations))+ ')' as Name,
'All (' +ltrim(str(
sum(nooforganizations) over()
)) + ')' as AllOrganizations
FROM TargetPersonaFilterIndustry
