/****** Object:  Procedure [dbo].[Public_GetOrganizationData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Anurag Gandhi   
-- Create date: 6 Feb, 2021   
-- Updated date: 6 Feb, 2021     
-- Description: Gets the Organization Details for Public API.//  
-- For Ashish to work
-- =============================================  
CREATE PROCEDURE [dbo].[Public_GetOrganizationData] 
    @OrganizationId int = 806257,
	@Limit int = 20
AS    
/*
[dbo].[Public_GetOrganizationData] 806257
*/
BEGIN
	SET NOCOUNT ON;

	select ''
	select ''
	select ''
	select ''
	select ''
	select ''
	select ''

	--SELECT top(@Limit)
	--	L.Id,
	--	L.[Name],
	--	L.[Url],
	--	o.[Name] as OrganizationName,
	--	L.ModifiedDesignation as Designation

	--FROM 
	--	LinkedInData L with (nolock)
	--	inner join Organization O with (nolock) on (O.Id = L.OrganizationId)
	--WHERE 
	--	OrganizationId = @OrganizationId

	--select distinct top 20 TeamName
	--from 
	--	cache.OrganizationTeams with (nolock)
	--where OrganizationId = @OrganizationId

	
	--select distinct top 20 C.[Name] as [Country]
	--from 
	--	cache.OrganizationTeams OT  with (nolock)
	--	inner join Country C on (C.Id = OT.CountryId)
	--where OrganizationId = @OrganizationId
	
	--select distinct top 20 OT.TeamName, C.[Name] as [Country]
	--from 
	--	cache.OrganizationTeams OT with (nolock)
	--	inner join Country C on (C.Id = OT.CountryId)
	--where 
	--	OrganizationId = @OrganizationId
	
	--select top 20 JobTitle, Summary,[Source], [Location] 
	--From
	--	IndeedJobPostLast6Months with (nolock)
	--where 
	--	OrganizationId=@OrganizationId AND jobDateDays<180

	--select top 20 Name  AS Company
	--from
	--Organization with (nolock)
	--where CountryId=(Select O.CountryId from 
	--Organization O where O.Id = @OrganizationId)
																					
	--Select top 20 O.[Name] as Company
	--	from Organization O with (nolock)
	--	inner join Industry I  on (I.id=O.IndustryId)
	--	AND I.IndustryGroupId = (select I.IndustryGroupId
	--from 
	--	Industry I
	--	inner join Organization O with (nolock)  on (I.id=O.IndustryId)
	--	where O.Id = @OrganizationId)

		
END


	
