/****** Object:  Procedure [dbo].[GetPartnerGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-2021 - KABIR
-- EXEC GetPartnerGraph 159
CREATE PROCEDURE [dbo].[GetPartnerGraph] @USERID INT
AS 
BEGIN
SET NOCOUNT ON;


-- HighScoring
SELECT COUNT(DISTINCT OrganizationID) AS HighScoring,COUNT(1) AS OtherProspectCount
FROM PartnerDashboardData
WHERE UserID = @USERID

-- COUNTRY
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,C.Name NAME
FROM PartnerDashboardData P
INNER JOIN Country C ON C.ID = P.CountryID
WHERE UserID = @UserID AND C.Name <> 'Unknown'
GROUP BY C.Name
ORDER BY 1 DESC

-- INDUSTRY
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,I.Name NAME
FROM PartnerDashboardData P
INNER JOIN Industry I ON I.Id = P.IndustryID
WHERE I.Name <> 'Unknown' AND UserID = @UserID
GROUP BY I.Name
ORDER BY 1 DESC

--EMP
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,EmployeeCount NAME
FROM PartnerDashboardData P
WHERE UserID = @UserID
GROUP BY EmployeeCount
ORDER BY 1 DESC
-- rev
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,Revenue NAME
FROM PartnerDashboardData P
WHERE UserID = @UserID
GROUP BY Revenue
ORDER BY 1 DESC

-- PRODUCT
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,S.Name NAME
FROM PartnerDashboardData P
INNER JOIN PartnerProductSolution S ON P.ProductAndSolutionID = S.KeyWordCategoryID
WHERE P.[Product= 0 & Solution= 1] = 0 AND UserID = @UserID
GROUP BY S.Name
ORDER BY 1 DESC

-- SOLUTION
SELECT TOP 4 COUNT(DISTINCT P.OrganizationID) VALUE,S.Name NAME
FROM PartnerDashboardData P
INNER JOIN PartnerProductSolution S ON P.ProductAndSolutionID = S.KeyWordCategoryID
WHERE P.[Product= 0 & Solution= 1] = 1 AND UserID = @UserID
GROUP BY S.Name
ORDER BY 1 DESC

END
