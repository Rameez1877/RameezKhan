/****** Object:  Procedure [dbo].[SpGetEmailPattern]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SpGetEmailPattern] (@p_OrganizationID int,
@p_DomainName nvarchar(max),
@p_FirstName nvarchar(max),
@p_LastName nvarchar(max),
@p_EmailID nvarchar(max),
@P_PatternId Int out)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @PatternId int
  DECLARE @EmailAddess nvarchar(max)
  DECLARE @firstLetterOfFirstName nvarchar(1)
  DECLARE @firstLetterOfLastName nvarchar(1)
  SET @firstLetterOfFirstName = SUBSTRING(@p_FirstName, 1, 1)
  SET @firstLetterOfLastName = SUBSTRING(@p_LastName, 1, 1)
  SET @firstLetterOfFirstName = LOWER(@firstLetterOfFirstName)
  SET @firstLetterOfLastName = LOWER(@firstLetterOfLastName)
  SET @p_FirstName = LOWER(@p_FirstName)
  SET @p_LastName = LOWER(@p_LastName)
  
  SET @EmailAddess = CONCAT(@p_FirstName, @p_LastName, '@', @p_DomainName)
  
   IF @EmailAddess = @p_EmailID
    SET @PatternId = 1
	print @PatternId
  IF @PatternId IS NULL
  BEGIN
  
    SET @EmailAddess = CONCAT(@firstLetterOfFirstName, @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 2
  END
  
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 3
  END
  IF @PatternId IS NULL

  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, @firstLetterOfLastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 4
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '.', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 5
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '+', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 6
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '-', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 7
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '_', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 8
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '.', @firstLetterOfLastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 9
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '-', @firstLetterOfLastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 10
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_FirstName, '_', @firstLetterOfLastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 11
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@firstLetterOfFirstName, '.', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 12
  END

  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@firstLetterOfFirstName, '-', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 13
  END

  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@firstLetterOfFirstName, '_', @p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 14
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_LastName, '.', @p_FirstName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 15
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@firstLetterOfLastName, @p_FirstName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 16
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_LastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 17
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@p_LastName, @firstLetterOfFirstName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 18
  END
  IF @PatternId IS NULL
  BEGIN
    SET @EmailAddess = CONCAT(@firstLetterOfFirstName, '-', @firstLetterOfLastName, '@', @p_DomainName)
    IF @EmailAddess = @p_EmailID
      SET @PatternId = 19
  END
  SET @P_PatternId = @PatternId
  
END
