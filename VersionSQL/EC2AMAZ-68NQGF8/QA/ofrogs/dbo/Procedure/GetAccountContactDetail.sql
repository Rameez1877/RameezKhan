/****** Object:  Procedure [dbo].[GetAccountContactDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Oct 10, 2021>
-- Description:	<Organization detail screen>
-- =============================================
CREATE PROCEDURE [dbo].[GetAccountContactDetail]
	@UserID INT,
	@OrganizationId INT,
	@Page INT = 0,
	@Size INT = 10,
	@Functionality VARCHAR(500) = '',
	--@Designation VARCHAR(1000) = '',
	@CountryName VARCHAR(200) = ''
	--@Name VARCHAR(200) = '',
	--@Organization VARCHAR(200)  = ''
AS
/*
[dbo].[QA_GetAccountContactDetail] 6121, 585266, 0,10, 'Finance', 'Head Of Finance -Continental Europe'
[dbo].[GetAccountContactDetail] 585266,6121 0,10, 'Finance', 'Head Of Finance -Continental Europe'

*/
BEGIN
	SET NOCOUNT ON;
	-- Set @OrganizationId = 585266
	DECLARE @AppRoleID int 
    SELECT
        @AppRoleID = AppRoleID
    FROM AppUser WHERE Id = @UserId

   select
	li.Id,
	li.[Name],
	li.FirstName,
	li.LastName,
	li.Designation,
	O.Name AS	Organization,
	li.ResultantCountry as Country,
	li.Url,
	IIF(@AppRoleID = 3 AND @Page > 1, '*', s.EmailId) as EmailId,
	STRING_AGG(mc.[Name], ',') as Functionality,
	COUNT(*) OVER (PARTITION BY @UserID) as TotalRecords
	from LinkedInData li with (nolock)
	inner join SurgeContactDetail s with (nolock) on (s.Url = li.url)
	inner join McDecisionmakerlist mc with (nolock) on (mc.DecisionMakerId = li.id)
	INNER JOIN Organization O ON O.ID = li.OrganizationId
	WHERE  li.organizationid = @OrganizationId AND LI.SeniorityLevel 
	IN ('C-Level','Director','Influencer','Affiliates/Consultants')
	AND (@Functionality = '' OR mc.[Name] LIKE '%' + @Functionality + '%')
	--AND (@Designation = '' OR li.Designation LIKE '%' + @Designation + '%')
	AND (@CountryName = '' OR li.ResultantCountry = @CountryName )
	--AND (@Name = '' OR li.[Name] LIKE '%' + @Name + '%')
 --   AND (@Organization = '' OR li.Organization LIKE '%' + @Organization + '%')
	group by 	
		li.Id,
		li.[Name],
		li.FirstName,
		li.LastName,
		li.Designation,
		O.Name ,
		li.ResultantCountry,
		li.[Url],
		s.EmailId
		order by EmailId
		OFFSET (@Page * @Size) ROWS
		FETCH NEXT @Size ROWS ONLY
END
