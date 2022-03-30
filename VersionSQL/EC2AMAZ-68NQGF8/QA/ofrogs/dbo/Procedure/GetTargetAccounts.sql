/****** Object:  Procedure [dbo].[GetTargetAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTargetAccounts] 
	@UserId int   ,
	@Page INT = 0,
@Size INT = 10,
@Name VARCHAR(500) = ''
AS      
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 06 June, 2019      
-- Updated date: 06 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts page.//      
-- =============================================      
-- [qa_GetTargetAccounts] 2
BEGIN
	update appuser set isnewuser = 0 where id = @UserId

	select T.Id, T.[Name], replace(T.EmployeeCounts,',',', ') EmployeeCounts , 
	replace(T.Revenues,',',', ') Revenues, T.CreateDate,T.Type,T.Segment, T.Intent, count(TPO.OrganizationId) as TotalAccounts,@UserId as UserId
	into #TargetPersona
	from
		TargetPersona T
		inner join TargetPersonaOrganization TPO on (T.Id = TPO.TargetPersonaId)
	
	where
		T.CreatedBy = @UserId
	group by
		T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate, T.Type, T.Segment, T.Intent

	
	select distinct  T.Id, T.[Name], CASE WHEN T.EmployeeCounts = '' THEN 'All' ELSE T.EmployeeCounts END as EmployeeCounts,
	CASE WHEN T.Revenues ='' THEN 'All' ELSE T.Revenues END as Revenues , T.CreateDate, T.Type, T.Segment, T.Intent, T.TotalAccounts,
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
		Technologies = CASE WHEN STUFF((SELECT ', ' + TPT.TechnologyName
				 from TargetPersonaTechnologyName TPT inner join TechStackTechnology Tc on (T.Id = TPT.TargetPersonaId)
				 where Tc.StackTechnologyName = TPT.TechnologyName
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') IS NULL THEN 'All' ELSE STUFF((SELECT distinct top 10 ', ' + Tc.StackTechnologyName
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
			,count(*) over(partition by userid) as TotalRecords
	from 
		#TargetPersona T
		WHERE (@Name = '' OR T.Name LIKE '%' + @Name + '%')
	order by T.Id desc
	OFFSET (@PAGE * @SIZE) ROWS
	FETCH NEXT @SIZE ROWS ONLY
END
