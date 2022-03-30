/****** Object:  Function [dbo].[fn_GetOrgName_Title]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fn_GetOrgName_Title] (@Input NVARCHAR(MAX),  @Character CHAR(1), @Name VARCHAR(1000))
RETURNS bit
AS 
BEGIN
	--DECLARE @Input NVARCHAR(MAX)
	--DECLARE @Character CHAR(1)
	--DECLARE @Name VARCHAR(100)
	--SET @Input='AIADMK removes Dhinakaran as deputy general secretary, Sasikala’s status not clear'
	--SET @Character =' '
	--SET @Name='ADM'

	SET @Input=REPLACE( REPLACE ( @Input,CHAR(13),' ' ), char(10),' ' )
   DECLARE @Output TABLE (
	      Item NVARCHAR(1000)
	)
	DECLARE @OutputName TABLE (
	      Item_Name NVARCHAR(1000)
	)

	  DECLARE @Result BIT
	  SET @Result=0
      DECLARE @StartIndex INT, @EndIndex INT

	  DECLARE  @stripchrs VARCHAR(255) 
		SET @stripchrs=',''/@!#&*()™;:"-’–.'--27 Aug 2018 added dot to tackle C2 Technologies. not getting tagid
		--SELECT @stripchrs
      DECLARE @charcounter INT
      SET @charcounter = 1
      WHILE  @charcounter <= LEN(@stripchrs)
      BEGIN
            SET @Input = REPLACE(@Input, SUBSTRING(@stripchrs, @charcounter, 1), ' ')
            SET @charcounter = @charcounter + 1
      END
		--SELECT @Input

      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
	
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
			
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END

	  --SELECT * FROM @Output

	  SET @StartIndex = 1
      IF SUBSTRING(@Name, LEN(@Name) - 1, LEN(@Name)) <> @Character
      BEGIN
            SET @Name = @Name + @Character
      END
	
      WHILE CHARINDEX(@Character, @Name) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Name)
           
            INSERT INTO @OutputName(Item_Name)
            SELECT SUBSTRING(@Name, @StartIndex, @EndIndex - 1)
           
            SET @Name = SUBSTRING(@Name, @EndIndex + 1, LEN(@Name))
      END

	  --SELECT t.Item FROM @Output t WHERE t.Item=@Name
	  --SELECT * FROM @Output t INNER JOIN @OutputName n On t.Item=n.Item_Name
	  UPDATE @Output SET Item=REPLACE(Item, char(9), '')
	  UPDATE @Output SET Item=REPLACE( REPLACE ( Item,CHAR(13),' ' ), char(10),' ' )

	  DECLARE  @NameWordCount INT
	  SELECT @NameWordCount=  COUNT(1) FROM @OutputName  

	  IF EXISTS  (SELECT 1 FROM @Output t INNER JOIN @OutputName n On t.Item=n.Item_Name)
	  BEGIN
		IF ((SELECT  COUNT(DISTINCT t.Item) FROM @Output t INNER JOIN @OutputName n On t.Item=n.Item_Name)=@NameWordCount)
		BEGIN
			SET @Result =1 
		END
	  END
	  ELSE
	  BEGIN
		SET @Result =0
	  END 
	  RETURN  @Result 
END;
