/****** Object:  Procedure [dbo].[GetPartnerDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

-- 03-DEC-2021 - KABIR
-- EXEC GetPartnerDashboardData 159
CREATE PROCEDURE [dbo].[GetPartnerDashboardData] @UserID INT
AS 
BEGIN 
SET NOCOUNT ON;

DELETE FROM PartnerDashboardData WHERE UserID = @UserID
DECLARE 
		@ProductSolution_ID  VARCHAR(500),
		@RegionID  VARCHAR(500),
		@IndustryGroupID VARCHAR(500) 
		
SELECT 
		@ProductSolution_ID = PartnerPersonaID,
		@RegionID = PartnerRegionID,
		@IndustryGroupID = PartnerIndustryGroupID
		FROM AppUser WHERE ID = @UserID

		
		;WITH CTE AS(
		SELECT DISTINCT 
		O.Id OrganizationID,C.ID CountryID,i.Id IndustryID,Revenue,Segment PartnerType,
		O.EmployeeCount,P.ID ProductAndSolutionID,P.[Product= 0 & Solution= 1]
		FROM 
		WebsiteNavigationSegment  WNS
		INNER JOIN PartnerProductSolution P
		ON P.KeyWordCategoryID = WNS.WebsiteIntentKeywordCategoryID
		INNER JOIN WebsiteOrganizationMapping W
		ON WNS.WebsiteId = W.WebSiteId
		INNER JOIN Organization O ON O.Id = W.OrganizationId
		INNER JOIN Country C ON C.ID = O.CountryId 
		INNER JOIN Industry I ON I.Id = O.IndustryId
		WHERE   
		WNS.WebsiteIntentKeywordCategoryID IN(SELECT DISTINCT KeyWordCategoryID 
		FROM PartnerProductSolution WHERE WebsiteIntentKeywordCategoryID IN 
		(SELECT VALUE FROM string_split(@ProductSolution_ID,',')))
		AND C.ID IN (SELECT DISTINCT ID FROM COUNTRY WHERE IsRegion IN (
		SELECT VALUE FROM string_split(@RegionID,',')))
		AND I.Id IN (SELECT DISTINCT ID FROM Industry WHERE IndustryGroupId IN (
		SELECT VALUE FROM string_split(@IndustryGroupID,',')))
		AND WNS.ISACTIVE = 1)

		INSERT INTO PartnerDashboardData (OrganizationID,CountryID,IndustryID,Revenue,PartnerType,
		EmployeeCount,ProductAndSolutionID,[Product= 0 & Solution= 1],TeamName,UserID)
		SELECT DISTINCT C.*,TeamName,@UserID
		FROM CTE C
		LEFT JOIN cache.OrganizationTeams T
		ON T.OrganizationId = C.OrganizationID
END
