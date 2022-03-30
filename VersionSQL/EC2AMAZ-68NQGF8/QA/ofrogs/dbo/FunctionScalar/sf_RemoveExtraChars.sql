/****** Object:  Function [dbo].[sf_RemoveExtraChars]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION sf_RemoveExtraChars (@NAME nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
  declare @TempString nvarchar(100)
  set @TempString = @NAME 
  set @TempString = LOWER(@TempString)
  set @TempString =  replace(@TempString,' ', '')
  set @TempString =  replace(@TempString,'à', 'a')
  set @TempString =  replace(@TempString,'è', 'e')
  set @TempString =  replace(@TempString,'é', 'e')
  set @TempString =  replace(@TempString,'ì', 'i')
  set @TempString =  replace(@TempString,'ò', 'o')
  set @TempString =  replace(@TempString,'ù', 'u')
  set @TempString =  replace(@TempString,'ç', 'c')
  set @TempString =  replace(@TempString,'''', '')
  set @TempString =  replace(@TempString,'`', '')
  set @TempString =  replace(@TempString,'ô', 'o')

  return @TempString
END
