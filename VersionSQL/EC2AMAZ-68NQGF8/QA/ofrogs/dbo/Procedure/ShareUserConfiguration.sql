/****** Object:  Procedure [dbo].[ShareUserConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <02nd Feb 2021>
-- Description:	<Share user platform configurations>
-- =============================================
CREATE PROCEDURE [dbo].[ShareUserConfiguration]
@UserId int,
@RecepientUserId int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM UserTargetCountry WHERE UserId = @RecepientUserId
	DELETE FROM UserTargetFunctionality WHERE UserId = @RecepientUserId
	DELETE FROM UserTargetTechnology WHERE UserId = @RecepientUserId

	INSERT INTO UserTargetCountry(UserId,CountryId)
	SELECT	@RecepientUserId,CountryId
	FROM	UserTargetCountry
	WHERE	UserId = @UserId

	INSERT INTO UserTargetFunctionality(UserId,Functionality,ApplyScore)
	SELECT	@RecepientUserId,Functionality,ApplyScore
	FROM	UserTargetFunctionality
	WHERE	UserId = @UserId

	INSERT INTO UserTargetTechnology(UserId,Technology,ApplyScore)
	SELECT	@RecepientUserId,Technology,ApplyScore
	FROM	UserTargetTechnology
	WHERE	UserId = @UserId
    
END
