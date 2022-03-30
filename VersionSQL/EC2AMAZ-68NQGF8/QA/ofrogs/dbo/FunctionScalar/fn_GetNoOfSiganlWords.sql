/****** Object:  Function [dbo].[fn_GetNoOfSiganlWords]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fn_GetNoOfSiganlWords] (@Input NVARCHAR(MAX),  @Character CHAR(1), @IndustryID INT,@signalID INT)
RETURNS INT
AS 
BEGIN
   DECLARE @Output TABLE (
	      Item NVARCHAR(1000)
	)
		DECLARE @Result BIT
      DECLARE @StartIndex INT, @EndIndex INT
 
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
	  
	  SELECT @Result= COUNT(1) FROM @Output t INNER JOIN SignalWord(NOLOCK) w ON t.Item=w.Name
	  INNER JOIN Signal (NOLOCK) s ON w.SignalId=s.id 
	  INNER JOIN industrysignal(NOLOCK) isl ON isl.SignalId=s.id
	  WHERE isl.IndustryId=@IndustryID AND s.id=@signalID

	 -- IF EXISTS  (SELECT 1 FROM @Output t INNER JOIN goodword(NOLOCK) w ON t.Item=w.Name AND IndustryId=@Type)
	 -- BEGIN
		--SET @Result =1 
	 -- END
	 -- ELSE
	 -- BEGIN
		--SET @Result =0
	 -- END 
	  RETURN  @Result 
END;
