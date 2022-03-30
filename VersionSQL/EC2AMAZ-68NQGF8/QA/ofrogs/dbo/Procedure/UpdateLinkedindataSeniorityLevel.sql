/****** Object:  Procedure [dbo].[UpdateLinkedindataSeniorityLevel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Update_Linkedindata_SeniorityLevel] as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   DECLARE @seniority varchar(50),
        @sequence int

DECLARE db_seniority CURSOR LOCAL FOR
SELECT DISTINCT
  senioritylevel seniority,
  sequence
FROM DecisionMakerList
where len(senioritylevel) > 3
ORDER BY sequence
OPEN db_seniority
 UPDATE linkedindata
  SET SeniorityLevel =null 
FETCH NEXT FROM db_seniority INTO @seniority, @sequence

WHILE @@FETCH_STATUS = 0
BEGIN

  UPDATE linkedindata
  SET linkedindata.SeniorityLevel = @seniority
  WHERE EXISTS (SELECT
    *
  FROM DecisionMakerList
  WHERE (
  CHARINDEX(' ' + DecisionMakerList.Keyword +' ', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +', ', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'/', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'-', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +')', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +'.', designation) > 0
  OR CHARINDEX(DecisionMakerList.Keyword +':', designation) > 0
  OR CHARINDEX( '('+ DecisionMakerList.Keyword, designation) > 0
  OR CHARINDEX('/'+ DecisionMakerList.Keyword, designation) > 0
  OR CHARINDEX('-'+ DecisionMakerList.Keyword, designation) > 0
  OR CHARINDEX('.'+ DecisionMakerList.Keyword, designation) > 0
  OR replace(DecisionMakerList.Keyword,' ','') = replace(designation,' ','')-- exactly equal
  OR  designation like '% '+ DecisionMakerList.Keyword-- after a space and keyword at the end and nothing else
  OR  designation like  DecisionMakerList.Keyword + ' %'--started with keyword and has space
  )
  AND DecisionMakerList.senioritylevel = @seniority
  and sequence = @sequence
  and IsActive =  1)
  AND linkedindata.SeniorityLevel IS NULL
  

  FETCH NEXT FROM db_seniority INTO @seniority, @sequence
END
CLOSE db_seniority
DEALLOCATE db_seniority

UPDATE linkedindata  SET SeniorityLevel ='Others'
WHERE  SeniorityLevel IS NULL

END
