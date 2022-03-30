/****** Object:  Procedure [dbo].[Public_GetOrganizationEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Anurag Gandhi   
-- Create date: 6 Feb, 2021   
-- Updated date: 6 Feb, 2021     
-- Description: Gets the Organization Details for Public API.//      
-- =============================================  
CREATE PROCEDURE [dbo].[Public_GetOrganizationEmployees] 
    @OrganizationId varchar(500) = 237263,
	@Limit int = 20
AS    
/*
[dbo].[Public_GetOrganizationEmployees] 237263
*/
BEGIN
	SET NOCOUNT ON;

	SELECT top(@Limit)
		L.Id,
		L.[Name],
		L.[Url],
		o.[Name] as OrganizationName,
		L.ModifiedDesignation as Designation
	FROM 
		LinkedInData L
		inner join Organization O on (O.Id = L.OrganizationId)
	WHERE 
		OrganizationId = @OrganizationId
END
