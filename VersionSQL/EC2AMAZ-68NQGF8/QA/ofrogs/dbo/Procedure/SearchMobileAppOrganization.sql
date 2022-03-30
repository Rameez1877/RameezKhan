/****** Object:  Procedure [dbo].[SearchMobileAppOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- 30-NOV-2021 - KABIR - SP will fetch organizations for user based on filters in MobileApp screen.
-- EXEC [SearchMobileAppOrganization] 159,'','','','',''
CREATE PROCEDURE [dbo].[SearchMobileAppOrganization] 
	@UserID int,
	@Country VARCHAR(200) = '',
	@Install VARCHAR(200) = '',
	@AppCategory VARCHAR(200) = '',
	@EmployeeCount VARCHAR(200) = '',
	@Revenue  VARCHAR(200) = ''
AS 
BEGIN 
SET NOCOUNT ON;

DECLARE @AppRoleID INT , @Limit INT

SELECT @AppRoleID = AppRoleID FROM APPUSER WHERE ID = @UserID

SET @Limit = (SELECT IIF(@AppRoleID = 3,200,10000))

	;WITH CTE AS(
	SELECT DISTINCT M.AppName,MC.AppCategory,O.Name Organization,md.organizationid,
	MD.InstallsNewFormat,md.InstallsOldFormat,MD.CountryID,MD.EmployeeCount,MD.Revenue
	,CASE
	WHEN O.GlassdoorDescription IS NULL THEN O.WebsiteDescription
	ELSE O.GlassdoorDescription END AS Description
	FROM MoblieAppDashboard MD
	INNER JOIN MOBILEAPPCATEGORY MC ON MD.AppCategoryID = MC.ID
	INNER JOIN Organization O ON O.Id = MD.OrganizationID
	INNER JOIN MobileAPP M ON M.ID = MD.AppID
	WHERE UserID = @UserID
	AND (@Country = '' OR md.CountryID in (SELECT VALUE FROM STRING_SPLIT(@Country,',')))
	AND (@AppCategory = '' OR md.AppCategoryID in (SELECT VALUE FROM STRING_SPLIT(@AppCategory,',')))
	AND (@Install = '' OR md.InstallsOldFormat in (SELECT VALUE FROM STRING_SPLIT(@Install,',')))
	AND (@EmployeeCount = '' OR md.EmployeeCount in (SELECT VALUE FROM STRING_SPLIT(@EmployeeCount,',')))
	AND (@Revenue = '' OR md.revenue in (SELECT VALUE FROM STRING_SPLIT(@Revenue,','))))
	
	SELECT DISTINCT TOP (@Limit)
	C.*,COUNT(1) DecisionMakerCount,
	SORTORDER = CASE WHEN AppName LIKE '%?%' OR Description 
	= '' OR Description IS NULL THEN 1 ELSE 0 END  
	FROM CTE C
	LEFT JOIN LinkedInData LI ON LI.ORGANIZATIONID = C.ORGANIZATIONID
	GROUP BY C.AppName,AppCategory,c.OrganizationID,InstallsNewFormat,InstallsOldFormat,Description,c.organization
		,CountryID,EmployeeCount,Revenue
		ORDER BY SORTORDER 
		
	END
