/****** Object:  Function [dbo].[RemoveNonExtenedASCII]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION RemoveNonExtenedASCII 
(
    @nstring nvarchar(MAX)
)
RETURNS varchar(MAX)
AS
BEGIN
	--DECLARE @nstring NVARCHAR(MAX)
	--SET @nstring='Octapharma doa Nuwiq® ao Programa de Ajuda Humanitária da Federação Mundial de Hematologia a fim de prover acesso à terapia a pacientes com hemofilia A em países em desenvolvimento'
	SET @nstring =REPLACE( REPLACE ( @nstring,CHAR(13),' ' ), char(10),' ' )
    DECLARE @Result varchar(MAX)
    SET @Result = ''
	--SET @Result = 0

    DECLARE @nchar nvarchar(1)
    DECLARE @position int

    SET @position = 1
    WHILE @position <= LEN(@nstring)
    BEGIN
        SET @nchar = SUBSTRING(@nstring, @position, 1)
        --Unicode & ASCII are the same from 1 to 255.
        --Only Unicode goes beyond 255
        --0 to 31 are non-printable characters
		--SELECT UNICODE(@nchar)
        IF( (UNICODE(@nchar) between 128 and 255))
		BEGIN
            --SET @Result = @Result + @nchar
			--SET @nstring=REPLACE(@nstring,@nchar,'?')
			--SELECT @position
			--SELECT UNICODE(@nchar) 
			--SELECT @nchar
			IF(@nchar NOT IN (' ','®','$','£'))
			BEGIN
				SET @Result = @Result + @nchar
			END
		END
		 SET @position = @position + 1
    END
	--SET @Result= @nstring
	--SELECT @result
    RETURN @Result
	
END
