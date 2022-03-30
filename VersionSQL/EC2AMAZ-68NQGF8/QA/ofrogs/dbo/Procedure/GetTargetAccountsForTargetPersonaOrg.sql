/****** Object:  Procedure [dbo].[GetTargetAccountsForTargetPersonaOrg]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[GetTargetAccountsForTargetPersonaOrg]
	@UserId int ,
	@TargetPersonaId int
AS      
-- =============================================      
-- Author:  Vijaya    
-- Create date: 14 June, 2019      
-- Updated date: 14 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts Details page.//      
-- =============================================      
-- [GetTargetAccounts] 2
BEGIN
	select T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate, count(TPO.OrganizationId) as TotalAccounts
	into #TargetPersona
	from
		TargetPersona T
		inner join TargetPersonaOrganization TPO on (T.Id = TPO.TargetPersonaId)
	where
		TPO.TargetPersonaId = @TargetPersonaId AND T.CreatedBy = @UserId
	group by
		T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate

	
	select distinct T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate, T.TotalAccounts,
		Countries = STUFF((SELECT ', ' + C.[Name]
				 from TargetPersonaCountry TPC inner join Country C on (T.Id = TPC.TargetPersonaId)
				 where C.Id = TPC.CountryId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,''),
		Industries = STUFF((SELECT ', ' + I.[Name]
				 from TargetPersonaIndustry TPI inner join Industry I on (I.Id = TPI.IndustryId)
				 where T.Id = TPI.TargetPersonaId
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,2,'')
	from 
		#TargetPersona T
	order by T.[Name]
END
