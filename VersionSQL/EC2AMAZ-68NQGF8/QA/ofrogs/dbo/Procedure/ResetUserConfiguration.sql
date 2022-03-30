/****** Object:  Procedure [dbo].[ResetUserConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ResetUserConfiguration] @UserId int
AS BEGIN
SET NOCOUNT ON;
	
Update AppUser set PersonaIds = '', RegionIds = '', IndustryGroupIds = '' where Id = @UserId


DELETE FROM [UserGraphContainer] WHERE userid = @UserID
DELETE FROM [UserFilters] WHERE UserID = @UserId
DELETE FROM [DashboardUserData] WHERE UserID = @UserId
DELETE FROM CompanySearchResult WHERE UserID = @UserId
DELETE FROM ContactSearchFunctionalityResult WHERE UserID = @UserId
--
DELETE FROM ContactListSearchResult WHERE UserID = @UserId
DELETE FROM TargetAccountTechnographicSearchResult WHERE UserID = @UserId
DELETE FROM TechnographicsSearchResult WHERE UserID = @UserId
DELETE FROM TouchPointSearchResult WHERE UserID = @UserId

END
