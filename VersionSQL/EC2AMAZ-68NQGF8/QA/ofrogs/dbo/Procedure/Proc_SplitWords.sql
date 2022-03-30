/****** Object:  Procedure [dbo].[Proc_SplitWords]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Proc_SplitWords
@Sentence VARCHAR(MAX)
AS
BEGIN
 SET NOCOUNT ON
    SET XACT_ABORT ON

 DECLARE @Words VARCHAR(MAX)
 DECLARE @tmpWord VARCHAR(MAX)
 DECLARE @t VARCHAR(MAX)
    DECLARE @I INT

    SET @Words = @Sentence    
    SELECT @I = 0

    WHILE(@I < LEN(@Words)+1)
    BEGIN
      SELECT @t = SUBSTRING(@words,@I,1)

      IF(@t != ' ')
      BEGIN
 SET @tmpWord = @tmpWord + @t
      END
      ELSE
      BEGIN
 PRINT @tmpWord
        SET @tmpWord=''
      END
 SET @I = @I + 1
        SET @t = ''
    END
   PRINT @tmpWord
END
