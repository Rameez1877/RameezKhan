/****** Object:  Procedure [dbo].[SaveTouchProfilesAppUsers_TEMP_TEST]    Committed by VersionSQL https://www.versionsql.com ******/

-- SELECT NAME FROM ORGANIZATION WHERE ID = 808689
-- EXEC [SaveTouchProfilesAppUsers_TEMP_TEST] 326,1950880,'Avanade',1
CREATE PROCEDURE [dbo].[SaveTouchProfilesAppUsers_TEMP_TEST]
	@AppUserID int,
	@NewHireProfileId int,
	@Org nvarchar(1000) = '',
	@IsTouched bit = 1
AS
BEGIN
	declare 
	@OrganizationID int = (Select Id from Organization where name = @Org), 
	@TouchDate Date

	INSERT INTO TouchProfilesAppUsers (AppUserID, NewHireProfileId,TouchDate, OrganizationID,
	IsTouched)
	SELECT TOP 1 
	@AppUserID, @NewHireProfileId, GETDATE(), @OrganizationID, @IsTouched
	FROM TouchProfilesAppUsers
	WHERE NOT EXISTS(
	Select 1 from TouchProfilesAppUsers where AppUserID=@AppUserID AND NewHireProfileId 
	= @NewHireProfileId)
	END
