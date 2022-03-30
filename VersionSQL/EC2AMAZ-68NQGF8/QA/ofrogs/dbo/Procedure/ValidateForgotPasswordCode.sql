/****** Object:  Procedure [dbo].[ValidateForgotPasswordCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ValidateForgotPasswordCode] 
    @verificationCode varchar(200)
AS
/*
[dbo].[ValidateForgotPasswordCode] 'aa785e8e-e962-4db0-9c6c-d0ca21c760e4-13a2bc35-5cb6-49ea-ba34-faa000f584e3'
*/
BEGIN
  SET NOCOUNT ON;
  DECLARE @createDate DATETIME,
		  @hours INT,
		  @result VARCHAR(12)

  SELECT
    @createDate = CreateDate
  FROM dbo.ForgotPassword
  WHERE Code = @verificationCode and IsActive = 1

  SELECT
    @hours = DATEDIFF(HOUR, @createDate, GETDATE())

  IF @hours <= 24
    SET @result = 'Valid'
  ELSE
    SET @result = 'Invalid'

  SELECT @result AS result

END
