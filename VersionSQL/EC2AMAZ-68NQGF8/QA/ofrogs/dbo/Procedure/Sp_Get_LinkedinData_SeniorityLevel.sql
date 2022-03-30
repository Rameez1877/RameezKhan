/****** Object:  Procedure [dbo].[Sp_Get_LinkedinData_SeniorityLevel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Get_LinkedinData_SeniorityLevel]
	-- Add the parameters for the stored procedure here
	@iD INT,
	@Title VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @seniority varchar(50),
        @sequence int,
		@Count Int

DECLARE db_seniority CURSOR FOR
SELECT DISTINCT
  senioritylevel seniority,
  sequence
FROM DecisionMakerList
where len(senioritylevel) > 3
and isactive=1
ORDER BY sequence
OPEN db_seniority

FETCH NEXT FROM db_seniority INTO @seniority, @sequence

WHILE @@FETCH_STATUS = 0
BEGIN

  SELECT
    @Count = count(*)
  FROM DecisionMakerList
  WHERE (
  CHARINDEX(' ' + DecisionMakerList.Keyword +' ', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +', ', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'/', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'-', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +')', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'.', @Title) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +':', @Title) > 0
  OR CHARINDEX( '('+ DecisionMakerList.Keyword, @Title) > 0
  OR CHARINDEX('/'+ DecisionMakerList.Keyword, @Title) > 0
  OR CHARINDEX('-'+ DecisionMakerList.Keyword, @Title) > 0
  OR CHARINDEX('.'+ DecisionMakerList.Keyword, @Title) > 0
  OR replace(DecisionMakerList.Keyword,' ','') = replace(@Title,' ','')-- exactly equal
  OR  @Title like '% '+ DecisionMakerList.Keyword -- after a space and keyword at the end and nothing else
  OR  @Title like  DecisionMakerList.Keyword + ' %'--started with keyword and has space
  )
  AND DecisionMakerList.senioritylevel = @seniority
  and sequence = @sequence
  and IsActive =  1
  If @Count > 0 
   break
   

  FETCH NEXT FROM db_seniority INTO @seniority, @sequence
END
CLOSE db_seniority
DEALLOCATE db_seniority

--If @seniority is null 
If @count = 0 
SET @seniority ='Others'

update LinkedInData set SeniorityLevel =  @seniority where id = @id

END
