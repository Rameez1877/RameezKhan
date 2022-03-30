/****** Object:  Function [dbo].[RemoveNonEngCharacterFromString]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[RemoveNonEngCharacterFromString] 
(
    @nstring nvarchar(MAX)
)
RETURNS varchar(MAX)
AS
BEGIN
	--DECLARE @nstring NVARCHAR(MAX)
	--SET @nstring='The pursuit of gender equality and womenâs empowerment is essential in crisis situations. A strong body of evidence exists that hunger and rural poverty can be reduced when gender equality is factored into programming. Men, women, boys and girls are exposed to different types of risks and challenges, and have specific coping strategies related to food and nutrition security. A [...]'
	DECLARE @FinalString NVARCHAR(MAX)
	SET @nstring =REPLACE( REPLACE ( @nstring,CHAR(13),' ' ), char(10),' ' )
	SET @FinalString=@nstring
	--select @FinalString
    DECLARE @Result varchar(MAX)
    SET @Result = ''
	--SET @Result = 0

    DECLARE @nchar nvarchar(1)
    DECLARE @position int
	
	--** Block to remove non english character**--
  --  SET @position = 1
  --  WHILE @position <= LEN(@nstring)
  --  BEGIN
  --      SET @nchar = SUBSTRING(@nstring, @position, 1)
  --      --Unicode & ASCII are the same from 1 to 255.
  --      --Only Unicode goes beyond 255
  --      --0 to 31 are non-printable characters
		----SELECT UNICODE(@nchar)
  --      IF( (UNICODE(@nchar) between 128 and 255))
		--BEGIN
  --          --SET @Result = @Result + @nchar
		--	--SET @nstring=REPLACE(@nstring,@nchar,'?')
		--	--SELECT @position
		--	--SELECT UNICODE(@nchar) 
		--	--SELECT @nchar
		--	IF(@nchar NOT IN (' ','®','$','£'))
		--	BEGIN
		--		SET @Result = @Result + @nchar
		--		--select @nchar
		--		SET @FinalString=REPLACE(@FinalString,@nchar,'')
		--	END
		--END
		-- SET @position = @position + 1
  --  END

	--** End Here**--
	--SET @Result= @nstring
	--SELECT @result
	--select @FinalString

	--** Code to remove HTML Entity**--

	--DECLARE @FinalString Nvarchar(max)= 'By Ron Kneebone In 2009, an estimated 147,000 people, or about one in 230 Canadians, stayed in an emergency homeless shelter. It is important to emphasize this is not the number of people experiencing homelessness; it is, instead, the number of people without a home who have exhausted all other options, and so been forced [&#8230;]<img alt="" border="0" src="http://pixel.wp.com/b.gif?host=calgaryherald.com&#038;blog=72533584&#038;post=625599&#038;subd=postmediacalgaryherald2&#038;ref=&#038;feed=1" width="1" height="1" />';
	DECLARE @resultString Nvarchar(max) = @FinalString
	DECLARE @temp Nvarchar(max) = '';
	IF(@resultString LIKE '%&#%')
	BEGIN
		WHILE @resultString != @temp
		BEGIN
			SET @temp = @resultString;
			--SELECT @resultString
			IF(@resultString LIKE '%&#%')
			BEGIN
				SELECT
					@resultString = Replace(@resultString COLLATE Latin1_General_CS_AS, [Entity Number], ISNULL(ReplaceChar,''))
				FROM
					htmlentity
			END
		END
	END
	--** To check HTML entity without semi colon at the end--
	SET @temp  = '';
	IF(@resultString LIKE '%&#%')
	BEGIN
		WHILE @resultString != @temp
		BEGIN
			SET @temp = @resultString;
			--SELECT @resultString
			IF(@resultString LIKE '%&#%')
			BEGIN
				SELECT
					@resultString = Replace(@resultString COLLATE Latin1_General_CS_AS, [Entity Number], ISNULL(ReplaceChar,''))
				FROM
					htmlentity WHERE CHARINDEX(';' ,[Entity Number])<=0
			END
		END
	END

	--** Ends here **--
	--SELECT @resultString
	--** End Here**--
	IF(ISNULL(@resultString,'')<>'')
	BEGIN
		SET @FinalString=@resultString
	END

    RETURN @FinalString

	--**Sample Code to remove html entity ****
	
			--DECLARE @inputString varchar(max)= '&amp;test&amp;quot;&lt;String&gt;&quot;&amp;';
			--DECLARE @resultString varchar(max) = @inputString;

			---- Simple HTML-decode:
			--SELECT
			--	@resultString = Replace(@resultString COLLATE Latin1_General_CS_AS, htmlName, NCHAR(asciiDecimal))
			--FROM
			--	@htmlNames
			--;

			--SELECT @resultString;
			---- Output: &test&quot;<String>"&


			---- Multiple HTML-decode:
			--SET @resultString = @inputString;

			--DECLARE @temp varchar(max) = '';
			--WHILE @resultString != @temp
			--BEGIN
			--	SET @temp = @resultString;

			--	SELECT
			--		@resultString = Replace(@resultString COLLATE Latin1_General_CS_AS, htmlName, NCHAR(asciiDecimal))
			--	FROM
			--		@htmlNames
			--	;
			--END;

			--SELECT @resultString;
			---- Output: &test"<String>"&
	--** End Here **--
	
END
