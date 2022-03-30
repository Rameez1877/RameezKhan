/****** Object:  View [dbo].[V_TargetPersonaFilterCountry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view [dbo].[V_TargetPersonaFilterCountry]
as
SELECT 
t.countryid as ID,
t.countryname,
t.nooforganizations,
t.countryname + '       ' + '('+ ltrim(str(t.nooforganizations))+ ')' as Name,
'All (' +ltrim(str(
sum(t.nooforganizations) over()
)) + ')' as AllOrganizations,
t.code,
c.IsRegion as RegionId
FROM TargetPersonaFilterCountry T
inner join Country c on T.CountryId = c.ID
WHERE t.IsCached = 1
