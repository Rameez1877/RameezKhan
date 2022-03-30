/****** Object:  Function [dbo].[FindPatternLocation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION dbo.FindPatternLocation
(
    @string NVARCHAR(MAX),
    @term   NVARCHAR(255)
)
RETURNS TABLE
AS
    RETURN 
    (
      SELECT pos = Number - LEN(@term) 
      FROM (SELECT Number, Item = LTRIM(RTRIM(SUBSTRING(@string, Number, 
      CHARINDEX(@term, @string + @term, Number) - Number)))
      FROM (SELECT ROW_NUMBER() OVER (ORDER BY rnum)
      FROM many_rows) AS n(Number)
      WHERE Number > 1 AND Number <= CONVERT(INT, LEN(@string)+1)
      AND SUBSTRING(@term + @string, Number, LEN(@term)) = @term
    ) AS y);
