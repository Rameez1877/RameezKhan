/****** Object:  Procedure [dbo].[GetAccountContactDetail_V1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Oct 10, 2021>
-- Description:	<Organization detail screen>
-- =============================================
CREATE PROCEDURE [dbo].[GetAccountContactDetail_V1]
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
	O.NAME AS Organization,
	li.ResultantCountry as Country,
	li.Url,
	IIF(@AppRoleID = 3 AND @Page > 1, '*', s.EmailId) as EmailId,
	STRING_AGG(mc.[Name], ',') as Functionality,
	COUNT(*) OVER (PARTITION BY @UserID) as TotalRecords
	from LinkedInData li with (nolock)
	inner join SurgeContactDetail s with (nolock) on (s.Url = li.url)
	inner join McDecisionmakerlist mc with (nolock) on (mc.DecisionMakerId = li.id)
	INNER JOIN Organization O ON O.ID = LI.OrganizationId
	WHERE  li.organizationid = @OrganizationId AND LI.SeniorityLevel 
	IN ('C-Level','Director','Influencer','Affiliates/Consultants')
	AND (@Functionality = '' OR mc.[Name] LIKE '%' + @Functionality + '%')
	AND (@CountryName = '' OR li.ResultantCountry = @CountryName )

	group by 	
		li.Id,
		li.[Name],
		li.FirstName,
		li.LastName,
		li.Designation,
		O.NAME,
		li.ResultantCountry,
		li.[Url],
		s.EmailId
		order by EmailId
		OFFSET (@Page * @Size) ROWS
		FETCH NEXT @Size ROWS ONLY
END
