/****** Object:  Procedure [dbo].[GetContactSearchResult]    Committed by VersionSQL https://www.versionsql.com ******/

-- 31-Jan-2022 -Kabir
-- EXEC [GetContactSearchResult] 159,30044,0,5000,'','','','',''
CREATE PROCEDURE [dbo].[GetContactSearchResult]
@UserID INT,
@TargetPersonaID INT,
@Page INT = 0,
@Size INT = 10,
@Functionality VARCHAR(500) = '',
--@Designation VARCHAR(1000) = '',
@CountryName VARCHAR(200) = ''
--@Name VARCHAR(200) = '',
--@Organization VARCHAR(200)  = ''
 
 AS 
 BEGIN
 SET NOCOUNT ON;

 DECLARE @AppRoleID int
 SELECT @AppRoleID = AppRoleId From AppUser where Id = @UserID


 ;WITH CTE AS(
	
    SELECT Distinct 
        li.Id as LinkedInId,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] , li.Designation AS [Username],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
		IIF(@AppRoleID = 3 AND @Page > 1, '*', s.EmailId) as EmailId,
        li.ResultantCountry AS Country,
		LI.ResultantCountryId,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.EmailGeneratedDate,
		@TargetPersonaID TargetPersonaCreateDate,
		O.WebsiteUrl,c.UserID 
    FROM 
	LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId) 
        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = li.OrganizationId )
        INNER JOIN SurgeContactDetail s with (nolock)
		on (li.url = s.Url)
		INNER JOIN Organization o with (nolock)
        on (o.Id = t.OrganizationId)
		INNER JOIN ContactListSearchResult C  with (nolock) ON C.ID= LI.id
		WHERE C.UserID = @UserID
		and t.TargetPersonaId = @TargetPersonaID
		)
		
		 SELECT distinct
		ROW_NUMBER() Over (Order by url)  as Id,
		LinkedInId,
        Gender,
        FirstName,
        LastName,
        c.[name] + ', '+ Designation AS [Username],
        c.[name],
        Designation,
        Organization,
		OrganizationId,
		EmailId,
        Country,
        [Url],
        C.[Functionality],
        SeniorityLevel,
		'' as Phone,
        EmailGeneratedDate,
        CONVERT(VARCHAR, TargetPersonaCreateDate, 106) as TargetPersonaCreateDate,
		WebsiteUrl,
		SUBSTRING (WebsiteUrl, CHARINDEX( '.', WebsiteUrl) + 1,
		LEN(WebsiteUrl)) AS [Domain]
		,count(*) over (partition by c.userid) as TotalRecords
		FROM CTE c
		WHERE
		Functionality IN (SELECT DISTINCT Functionality 
		FROM ContactSearchFunctionalityResult WHERE UserID = @UserID)
		AND 
		(@Functionality = '' OR C.Functionality = @Functionality)
		--AND (@Designation = '' OR designation LIKE '%' + @Designation + '%')
		AND (@CountryName = '' OR Country = @CountryName)
		--AND (@Name = '' OR [Username] LIKE '%' + @Name + '%')
		--AND (@Organization = '' OR Organization LIKE '%' + @Organization + '%')
		ORDER BY url
		OFFSET (@Page * @Size) ROWS
		FETCH NEXT @Size ROWS ONLY
END
