/****** Object:  Function [dbo].[StripHTML]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[StripHtml] (@HTMLText VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
 DECLARE @Start  INT
 DECLARE @End    INT
 DECLARE @Length INT
 DECLARE @TempStr varchar(255)

 SET @Start = CHARINDEX('<',@HTMLText)
 SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
 SET @Length = (@End - @Start) + 1

 WHILE @Start > 0 AND @End > 0 AND @Length > 0
 BEGIN
   IF (UPPER(SUBSTRING(@HTMLText, @Start, 3)) <> '<BR') AND (UPPER(SUBSTRING(@HTMLText, @Start, 2)) <> '<P') AND (UPPER(SUBSTRING(@HTMLText, @Start, 2)) <> '<B') AND (UPPER(SUBSTRING(@HTMLText, @Start, 3)) <> '</B')
   BEGIN
      SET @HTMLText = STUFF(@HTMLText,@Start,@Length,'')
   END
    
   SET @Start = CHARINDEX('<',@HTMLText, @End)
   SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText, @Start))
   SET @Length = (@End - @Start) - 1
 END

 RETURN RTRIM(LTRIM(@HTMLText))
END
