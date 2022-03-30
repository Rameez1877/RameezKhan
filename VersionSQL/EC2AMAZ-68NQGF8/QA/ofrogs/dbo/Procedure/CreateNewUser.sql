/****** Object:  Procedure [dbo].[CreateNewUser]    Committed by VersionSQL https://www.versionsql.com ******/

	-- =============================================
-- Author:		<Neeraj>
-- Create date: <18th Feb 2021>
-- Description:	<Create new user accounts>
-- =============================================
CREATE PROCEDURE CreateNewUser
@Name varchar(100),
@EmailId varchar(100),
@ApproleId int,
@FirstName varchar(100) = NULL,
@LastName varchar(100) = NULL,
@OrganizationName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @UserId int
	DECLARE @Password varchar(100)
	DECLARE @Name2 varchar(100)

	IF NOT EXISTS (SELECT 1 FROM AppUser WHERE Username = @EmailId)
		BEGIN
			INSERT INTO AppUser(Name,Username,Password,Email,AppRoleId,IsActive,FirstName,LastName,InsertedDate,NumberOfCountriesAllowed,
								NumberOfMarketingListsAllowed,OrganizationName) values
			(@Name,@EmailId,'oceanfrogsisbest',@EmailId,@ApproleId,1,@FirstName,@LastName,GETDATE(),10,7,@OrganizationName)

			SELECT @UserId = Id,@Password = Password FROM AppUser WHERE Username = @EmailId

			PRINT 'UserId = ' + trim(str(@UserId)) + ' | Name = ' + @Name +' | UserName = ' + @EmailId + ' | Password = ' + @Password
		END
	ELSE
		BEGIN
			SELECT @UserId = Id,@Name2=Name,@Password = Password FROM AppUser WHERE Username = @EmailId
			PRINT 'User already exists with ''UserId = ' + trim(str(@UserId)) + ' | Name = ' + @Name2 +' | UserName = ' + @EmailId + ' | Password = ' + @Password
		END
    
END
	



	
