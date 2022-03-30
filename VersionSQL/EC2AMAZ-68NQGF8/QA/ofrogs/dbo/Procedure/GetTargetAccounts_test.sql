/****** Object:  Procedure [dbo].[GetTargetAccounts_test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTargetAccounts_test] 
	@UserId int   
AS      
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 06 June, 2019      
-- Updated date: 06 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts page.//      
-- =============================================      
-- [GetTargetAccounts] 2
BEGIN

	select string_agg(m.marketinglistname,',') as MarketingListName,
	string_agg(m.id,',') as MarketingListId, t.id into #marketinglist From targetpersona t
	left outer join marketinglists m on t.id = m.TargetPersonaId
	where t.CreatedBy = @UserId
	group by t.id

	select T.Id, T.[Name], replace(T.EmployeeCounts,',',', ') EmployeeCounts , 
	replace(T.Revenues,',',', ') Revenues, T.CreateDate,T.Type,T.Segment, count(TPO.OrganizationId) as TotalAccounts
	into #TargetPersona
	from
		TargetPersona T
		inner join TargetPersonaOrganization TPO on (T.Id = TPO.TargetPersonaId)
	
		--inner  join cte ls on (ls.OrganizationID =TPO.OrganizationId) 
	where
		T.CreatedBy = @UserId
	group by
		T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate, T.Type, T.Segment--,ls.TotalScore,
	
	--select *
	--from (
	
	select distinct  T.Id, T.[Name], CASE WHEN T.EmployeeCounts = '' THEN 'All' ELSE T.EmployeeCounts END as EmployeeCounts,
	CASE WHEN T.Revenues ='' THEN 'All' ELSE T.Revenues END as Revenues , T.CreateDate, T.Type, T.Segment, T.TotalAccounts,
		m.marketinglistid, m.marketinglistname,
		
		Countries = CASE WHEN  STUFF((SELECT ', ' + C.[Name]
				 from TargetPersonaCountry TPC inner join Country C on (T.Id = TPC.TargetPersonaId)
				 where C.Id = TPC.CountryId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') IS NULL THEN 'All' ELSE STUFF((SELECT ', ' + C.[Name]
				 from TargetPersonaCountry TPC inner join Country C on (T.Id = TPC.TargetPersonaId)
				 where C.Id = TPC.CountryId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'')END ,
		Industries = CASE WHEN STUFF((SELECT ',  ' + I.[Name]
				 from TargetPersonaIndustry TPI inner join Industry I on (I.Id = TPI.IndustryId)
				 where T.Id = TPI.TargetPersonaId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') IS NULL then 'All' ELSE STUFF((SELECT top 10 ',  ' + I.[Name]
				 from TargetPersonaIndustry TPI inner join Industry I on (I.Id = TPI.IndustryId)
				 where T.Id = TPI.TargetPersonaId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'')END,
		Technologies = CASE WHEN STUFF((SELECT ', ' + Tc.StackTechnology
				 from TargetPersonaTechnologyName TPT inner join TechStackTechnology Tc on (T.Id = TPT.TargetPersonaId)
				 where Tc.StackTechnologyName = TPT.TechnologyName
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') IS NULL THEN 'All' ELSE STUFF((SELECT top 10 ', ' + Tc.StackTechnologyName
				 from TargetPersonaTechnologyName TPT inner join TechStackTechnology Tc on (T.Id = TPT.TargetPersonaId)
				 where Tc.StackTechnologyName = TPT.TechnologyName
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') END ,
		GicCountries = CASE WHEN STUFF((SELECT ', ' + C.[Name]
				 from TargetPersonaGIC TPG inner join Country C on (T.Id = TPG.TargetPersonaId)				
				 where C.Id = TPG.CountryId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') IS NULL THEN 'All' ELSE STUFF((SELECT ', ' + C.[Name]
				 from TargetPersonaGIC TPG inner join Country C on (T.Id = TPG.TargetPersonaId)				
				 where C.Id = TPG.CountryId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') END
			
	from 
		#TargetPersona T
		inner join #MarketingList m on (T.id = m.id)
		--)
		--as Tap order by tap.Countries,tap.Industries,tap.Revenues,tap.EmployeeCounts
	order by T.Id desc
END
