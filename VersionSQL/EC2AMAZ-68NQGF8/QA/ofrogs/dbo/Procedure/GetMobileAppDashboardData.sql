/****** Object:  Procedure [dbo].[GetMobileAppDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

-- 30-NOV-2021 - KABIR - SP will insert data after saving configuration from MobileApp onboarding.
-- EXEC [GetMobileAppDashboardData] 159
CREATE PROCEDURE [dbo].[GetMobileAppDashboardData] @UserID int
AS 
BEGIN 
SET NOCOUNT ON;

DELETE FROM MoblieAppDashboard WHERE UserID = @UserID

 DECLARE @AppCategoryID varchar(100) = '',
          @RegionIds varchar(100) = '',
          @IndustryGroupIds varchar(100) = ''
		  
		  SELECT @AppCategoryID = MobileAppCategoryIDs,
		  @IndustryGroupIds = MobileAppIndustryGroupIds,@RegionIds = MobileAppRegionIds
		  FROM APPUSER WHERE ID = @USERID

	;WITH CTE AS(
	SELECT  m.ID AppID,M.OrganizationID,
	O.Revenue,O.EmployeeCount,o.CountryId CountryID,
	o.IndustryId IndustryID,m.AppCategoryID
	,CASE Installs 
WHEN '0+' THEN '0-10'
WHEN '1+' THEN '1-10'
WHEN '1,000+' THEN '1K'
WHEN '1,000,000+' THEN '1M'
WHEN '1,000,000,000+' THEN '1B'
WHEN '10+' THEN '10-100'
WHEN '10,000+' THEN '10K'
WHEN '10,000,000+' THEN '10M'
WHEN '100+' THEN '100-1K'
WHEN '100,000+' THEN '100K'
WHEN '100,000,000+' THEN '100M'
WHEN '5+' THEN '5-10'
WHEN '5,000+' THEN '5K'
WHEN '5,000,000+' THEN '5M'
WHEN '5,000,000,000+' THEN '5B'
WHEN '50+' THEN '50-100'
WHEN '50,000+' THEN '50K'
WHEN '50,000,000+' THEN '50M'
WHEN '500+' THEN '500-1K'
WHEN '500,000+' THEN '500K'
WHEN '500,000,000+' THEN '500M' 
END AS InstallsNewFormat
	FROM MobileAPP M WITH (NOLOCK)
	INNER JOIN Organization O WITH (NOLOCK) ON M.OrganizationID = O.Id
	WHERE 
	o.CountryId in (SELECT ID FROM Country WHERE IsRegion IN 
	(SELECT VALUE FROM string_split(@RegionIds,',')))

	AND o.IndustryId IN (SELECT ID FROM Industry WHERE IndustryGroupId IN 
	(SELECT VALUE FROM string_split(@IndustryGroupIds,
	',')))

	AND M.AppCategoryID IN (SELECT ID FROM MobileAppCategory WHERE ID IN 
	(SELECT VALUE FROM string_split(@AppCategoryID,
	','))))
	INSERT INTO MoblieAppDashboard

	SELECT DISTINCT C.*,M.Installs,@UserId UserID --INTO MoblieAppDashboard
	FROM CTE C
	INNER JOIN MOBILEAPP M ON C.APPID = M.ID 

END
