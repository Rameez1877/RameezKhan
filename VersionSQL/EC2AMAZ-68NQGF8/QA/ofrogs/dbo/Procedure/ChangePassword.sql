/****** Object:  Procedure [dbo].[ChangePassword]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ChangePassword]
	@UserId int,
	@Password varchar(150),
	@CurrentPassword varchar(150)
AS
/*
	[dbo].[ChangePassword] 2, 'Gandhi13', 'Gandhi15'
*/
BEGIN
	SET NOCOUNT ON;

	if not exists(select 1 from AppUser where Id = @UserId and [Password] = @CurrentPassword)
		THROW 50001, 'Invalid Current Password.', 1;
		-- RAISERROR (N'Invalid Password', 10, 1);
	else
	BEGIN
		update AppUser
		set
			[Password] = @Password
		where
			Id = @UserId
	END
END
