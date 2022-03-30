/****** Object:  Procedure [dbo].[UpdateAppUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Asef Daqiq>
-- Create date: <11 Feb 2022>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateAppUser @UserId int, @CustomerType varchar(50)

AS
BEGIN

  SET NOCOUNT ON;

  UPDATE AppUser
  SET CustomerType = @CustomerType
  WHERE Id = @UserId


  SELECT
    a.Id,
    a.Email,
    a.Username,
    a.[Name],
    r.[Name] AS [Role],
    a.CustomerType
  FROM AppUser a
  INNER JOIN AppRole r
    ON (a.AppRoleId = r.Id)
  WHERE a.Id = @UserId


END
