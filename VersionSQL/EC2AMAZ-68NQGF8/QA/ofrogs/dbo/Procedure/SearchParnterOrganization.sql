/****** Object:  Procedure [dbo].[SearchParnterOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-2021 - KABIR
-- EXEC SearchParnterOrganization 159,'','','','','',''
CREATE PROCEDURE [dbo].[SearchParnterOrganization] @UserID INT,
		@CountryID VARCHAR(500) = '',
		@IndustryID VARCHAR(500) = '',
		@Revenue VARCHAR(500) = '',
		@ProductSolutionID VARCHAR(500) = '',
		@Team VARCHAR(500) = '',
		@EmployeeCount VARCHAR(500) = ''
AS 
BEGIN 
SET NOCOUNT ON;

DECLARE @AppRoleID INT,@Limit INT

SELECT @AppRoleId = AppRoleId
FROM AppUser
WHERE ID = @UserID

SET @Limit = IIF(@AppRoleID = 3, 200,10000)

		SELECT DISTINCT TOP (@Limit)
		O.Name Organization,C.Name Country,i.Name Industry,p.Revenue,p.PartnerType
		FROM PartnerDashboardData P
		INNER JOIN Organization O ON P.OrganizationID = O.Id
		INNER JOIN Country C ON P.CountryID = C.ID
		INNER JOIN Industry I ON I.Id = P.IndustryID
		INNER JOIN PartnerProductSolution PP ON P.ProductAndSolutionID = PP.KeyWordCategoryID
		WHERE 
		(@CountryID = '' OR P.CountryID 
		IN (SELECT VALUE FROM string_split(@CountryID,',')))
		AND (@IndustryID = '' OR P.IndustryID 
		IN (SELECT VALUE FROM string_split(@IndustryID,',')))
		AND (@Revenue = '' OR P.Revenue 
		IN (SELECT VALUE FROM string_split(@Revenue,',')))
		AND (@Team = '' OR P.TeamName 
		IN (SELECT VALUE FROM string_split(@Team,',')))
		AND (@EmployeeCount = '' OR P.EmployeeCount 
		IN (SELECT VALUE FROM string_split(@EmployeeCount,',')))
		AND (@ProductSolutionID = '' OR P.ProductAndSolutionID 
		IN (SELECT VALUE FROM string_split(@ProductSolutionID,',')))
		AND P.UserID = @UserID
		ORDER BY P.Revenue
		END
