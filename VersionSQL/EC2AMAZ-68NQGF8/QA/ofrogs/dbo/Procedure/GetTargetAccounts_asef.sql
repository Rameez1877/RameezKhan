/****** Object:  Procedure [dbo].[GetTargetAccounts_asef]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTargetAccounts_asef]
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

	
	select T.Id, T.[Name], replace(T.EmployeeCounts,',',', ') EmployeeCounts ,T.Locations as Countries, T.Industries, T.Technologies,
	T.Gics,
	replace(T.Revenues,',',', ') Revenues, T.CreateDate,T.Type,T.Segment, count(TPO.OrganizationId) as TotalAccounts

	into #TargetPersona
	from
		TargetPersona T
		inner join TargetPersonaOrganization TPO on (T.Id = TPO.TargetPersonaId)
	where
		T.CreatedBy = @UserId
	group by
		T.Id, T.[Name], T.EmployeeCounts, T.Revenues, T.CreateDate, T.Type, T.Segment,T.Locations, T.Industries, T.Technologies, T.Gics

	select distinct T.Id, T.[Name], CASE WHEN T.EmployeeCounts = '' THEN 'All' ELSE T.EmployeeCounts END as EmployeeCounts,
	CASE WHEN T.Revenues ='' THEN 'All' ELSE T.Revenues END as Revenues , T.CreateDate, T.Type, T.Segment, T.TotalAccounts,
	CASE WHEN T.Countries ='' THEN 'All' ELSE T.Countries END as Countries,
	CASE WHEN T.Industries ='' THEN 'All' ELSE T.Industries END as Industries,
	CASE WHEN T.Technologies ='' THEN 'All' ELSE T.Technologies END as Technologies,
	CASE WHEN T.Gics ='' THEN 'All' ELSE T.Gics END as GicCountries	
	from 
		#TargetPersona T
	order by T.Id desc
END
