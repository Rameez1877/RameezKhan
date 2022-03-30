/****** Object:  Procedure [dbo].[GetAppUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAppUser]
	@UserId int
AS
BEGIN
	SELECT Name, IsNewUser,PersonaIds,CustomerType, RegionIds, industryGroupIds, revenueCategoryIds, StackTechnologyNameIds, IsOnboardingComplete  from AppUser where id= @UserId;
END

/*
[dbo].[GetAppUser] 1

*/
