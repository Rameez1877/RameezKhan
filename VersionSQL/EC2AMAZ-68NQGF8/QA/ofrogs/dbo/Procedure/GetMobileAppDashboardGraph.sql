/****** Object:  Procedure [dbo].[GetMobileAppDashboardGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- 30-NOV-2021 - KABIR - SP will populate graph for user in MobileApp Dashboard.
-- EXEC [GetMobileAppDashboardGraph] 159
CREATE PROCEDURE [dbo].[GetMobileAppDashboardGraph] @UserID int
AS 
BEGIN 
SET NOCOUNT ON;

	-- HighScoring
	SELECT TOP 4 COUNT(DISTINCT AppID) AS ApplicationAccounts , COUNT(DISTINCT OrganizationID) AS OrganizationAccounts
	FROM MoblieAppDashboard
	WHERE UserID = @UserID

	-- Revenue
	SELECT TOP 4 COUNT(DISTINCT AppID) AS VALUE , Revenue AS NAME
	FROM MoblieAppDashboard
	WHERE UserID = @UserID
	GROUP BY Revenue
	ORDER BY 1 DESC

	-- Emp
	SELECT TOP 4 COUNT(DISTINCT AppID)  AS VALUE , EmployeeCount AS NAME
	FROM MoblieAppDashboard
	WHERE UserID = @UserID
	GROUP BY EmployeeCount
	ORDER BY 1 DESC

	--Installs
	SELECT TOP 4 COUNT(DISTINCT AppID)  AS VALUE , InstallsNewFormat AS NAME
	FROM MoblieAppDashboard
	WHERE UserID = @UserID
	GROUP BY InstallsNewFormat
	ORDER BY 1 DESC

	-- Country
	SELECT TOP 4 COUNT(DISTINCT AppID)  AS VALUE , C.Name  AS NAME
	FROM MoblieAppDashboard
	INNER JOIN Country C ON C.ID = CountryID
	WHERE UserID = @UserID
	GROUP BY C.Name
	ORDER BY 1 DESC

	--Industry
	SELECT TOP 4 COUNT(DISTINCT AppID)  AS VALUE , I.Name  AS NAME
	FROM MoblieAppDashboard
	INNER JOIN Industry I ON I.Id = IndustryID
	WHERE UserID = @UserID
	GROUP BY I.Name
	ORDER BY 1 DESC

	--AppCategory
	SELECT TOP 4 COUNT(DISTINCT AppID)  AS VALUE , M.AppCategory  AS NAME
	FROM MoblieAppDashboard
	INNER JOIN MobileAppCategory M ON M.ID = AppCategoryID
	WHERE UserID = @UserID
	GROUP BY  M.AppCategory
	ORDER BY 1 DESC

	


END
