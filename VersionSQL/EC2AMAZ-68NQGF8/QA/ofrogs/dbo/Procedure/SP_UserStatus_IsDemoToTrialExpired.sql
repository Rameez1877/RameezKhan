/****** Object:  Procedure [dbo].[SP_UserStatus_IsDemoToTrialExpired]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure SP_UserStatus_IsDemoToTrialExpired
AS
BEGIN

-- This is to transform Demo Users to Trial Users after a week

UPDATE [ofrogs].[dbo].[AppUser]
SET
AppRoleId = 8
WHERE AppRoleId =3 and IsActive=1 and DATEDIFF(day, InsertedDate, GETDATE()) >= 7

END
