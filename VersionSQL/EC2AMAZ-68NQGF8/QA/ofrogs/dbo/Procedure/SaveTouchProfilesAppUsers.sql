/****** Object:  Procedure [dbo].[SaveTouchProfilesAppUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- 07-JAN-2022
-- DELETE FROM TouchProfilesAppUsers WHERE APPUSERID = 159
-- SELECT NAME FROM ORGANIZATION WHERE ID = 808689
-- EXEC [SaveTouchProfilesAppUsers] 159,4683,'Bajaj Allianz Life Insurance',1
CREATE PROCEDURE [dbo].[SaveTouchProfilesAppUsers]
	@AppUserID int,
	@NewHireProfileId int,
	@OrgID INT,
	@IsTouched bit = 1
AS
BEGIN

	INSERT INTO TouchProfilesAppUsers (AppUserID, NewHireProfileId,TouchDate, OrganizationID,
	IsTouched)
	SELECT TOP 1 
	@AppUserID, @NewHireProfileId, GETDATE(), @OrgID, @IsTouched
	FROM TouchProfilesAppUsers
	WHERE NOT EXISTS(
	Select 1 from TouchProfilesAppUsers where AppUserID=@AppUserID AND NewHireProfileId 
	= @NewHireProfileId)
	END
	
