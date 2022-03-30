/****** Object:  Function [dbo].[fn_GetJobTech_Func_Title]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fn_GetJobTech_Func_Title] (@Input NVARCHAR(2000), @Type VARCHAR(50))
RETURNS VARCHAR(100)
AS 
BEGIN
	--DECLARE @Input NVARCHAR(MAX)
	DECLARE @Character CHAR(1)
	DECLARE @Name VARCHAR(100)
	DECLARE @OriginalInput NVARCHAR(2000)
	SET @OriginalInput=@Input
	--DECLARE @Type VARCHAR(50)
	--SET @Type='Technology'
	--SET @Input='Solution Analyst – Robotics Automation – Java or .NET-Deloitte -Orlando, FL'
	--SET @Character =' '
	--SET @Name='ADM'
	
	--SELECT * FROM TechStackTechnology(NOLOCK)
	  --WHERE StackTechnology LIKE '%@Input%'

	    DECLARE  @stripchrs VARCHAR(255) 
		SET @stripchrs=',''/@!#$&*();:"’-'
		--SELECT @stripchrs
      DECLARE @charcounter INT
      SET @charcounter = 1
      WHILE  @charcounter <= LEN(@stripchrs)
      BEGIN
            SET @Input = REPLACE(@Input, SUBSTRING(@stripchrs, @charcounter, 1), ' ')
            SET @charcounter = @charcounter + 1
      END

	  --SELECT @Input
	  --SELECT  * FROM TechStackTechnology(NOLOCK)
	  --WHERE @Input  LIKE '%'+StackTechnology+' %'-- Order By ID 

	  IF(@Type='Technology')
	  BEGIN
		--SELECT  TOP 1 @Name= StackTechnologyName FROM TechStackTechnology(NOLOCK)
	 -- WHERE @Input  LIKE '%'+StackTechnology+' %' --Order By ID 
	  select   @Name = stuff (( select distinct',' +  StackTechnologyName
                    from TechStackTechnology
					WHERE CASE WHEN LEN(StackTechnologyName)>1 THEN  @Input ELSE  @OriginalInput END
					  LIKE CASE WHEN LEN(StackTechnologyName)>1 THEN  '%'+StackTechnology+' %' ELSE '% '+StackTechnology+' %' END
                    for xml path('')), 1, 1, '') 
	  END

	  IF(@Type='Functionality')
	  BEGIN
		--SELECT  TOP 1 @Name= FunctionalityName FROM JobFunctionality(NOLOCK)
	 -- WHERE @Input  LIKE '%'+Functionality+' %'
	 select   @Name = stuff (( select distinct',' +  FunctionalityName
                    from JobFunctionality
					WHERE @Input  LIKE '%'+Functionality+' %'
                    for xml path('')), 1, 1, '') 
	  END

	  --SELECT @Name

 
	  RETURN  @Name 
END;
