/****** Object:  Function [dbo].[RemovePunctuation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[RemovePunctuation]
(
	@String varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	DECLARE @i int = (SELECT PATINDEX('%[^a-z^0-9 ]%', @String))

	WHILE (@i > 0)
	BEGIN
		  SET @String = (SELECT REPLACE(@String, SUBSTRING(@String, @i, 1), ' '))
		  SET @i = (SELECT PATINDEX('%[^a-z^0-9 ]%', @String))
	END
	SET @String = REPLACE(@String, '  ', ' ')

	return @String
END
