/****** Object:  Function [dbo].[fn_remove_Chars]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fn_remove_Chars]
      (
      @inputstr VARCHAR(4096)
      --, @stripchrs VARCHAR(255)
      )
RETURNS VARCHAR(4096)
AS  
BEGIN 
--DECLARE @inputstr VARCHAR(4096)
--SET @inputstr='Delta’s Pilots Seek Big Windfall as Airline’s Earnings Surge'
		DECLARE  @stripchrs VARCHAR(255) 
		SET @stripchrs=',''’/@!#$&*();:™"-.'
		--SELECT @stripchrs
      DECLARE @charcounter INT
      SET @charcounter = 1
      WHILE  @charcounter <= LEN(@stripchrs)
      BEGIN
            SET @inputstr = REPLACE(@inputstr, SUBSTRING(@stripchrs, @charcounter, 1), '^')
            SET @charcounter = @charcounter + 1
      END
	  --SELECT @inputstr
RETURN @inputstr
END
