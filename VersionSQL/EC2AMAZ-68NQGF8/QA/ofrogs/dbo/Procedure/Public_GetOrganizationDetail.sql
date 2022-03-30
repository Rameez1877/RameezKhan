/****** Object:  Procedure [dbo].[Public_GetOrganizationDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Anurag Gandhi   
-- Create date: 6 Feb, 2021   
-- Updated date: 6 Feb, 2021     
-- Description: Gets the Organization Details for Public API.//      
-- =============================================  
CREATE PROCEDURE [dbo].[Public_GetOrganizationDetail] 
    @OrganizationName varchar(500) = 'Infosys Limited'
AS    
BEGIN
	SET NOCOUNT ON;
	set @OrganizationName = REPLACE(@OrganizationName, '-', ' ')

  SELECT
    -- *,
    o.Id,
    O.[Name],
    case when O.WebsiteUrl like '%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
    o.[Description],
	o.CountryId,
	O.[Description],
	C.[Name] as CountryName
  FROM 
    Organization O
    left join Industry I on (I.Id = O.IndustryId)
	left join Country C on (C.Id = O.CountryId)
  WHERE 
    O.[Name] = @OrganizationName
    or O.Name2 = @OrganizationName
    or O.FullName = @OrganizationName
END
