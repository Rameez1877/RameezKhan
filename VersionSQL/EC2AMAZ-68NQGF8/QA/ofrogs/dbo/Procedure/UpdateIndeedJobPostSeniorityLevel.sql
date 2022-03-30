/****** Object:  Procedure [dbo].[UpdateIndeedJobPostSeniorityLevel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	Janna
-- Create date: 25th June 2019
-- Description:	Update Seniority Level in IndeedJobPost
-- Took 34 minutes on 25/6/2019
-- =============================================
CREATE PROCEDURE Sp_Update_IndeedJobPost_SeniorityLevel
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  SELECT
    IndeedJobPost.Id,
    IndeedJobPost.Jobtitle,
    DecisionMakerList.Keyword,
    DecisionMakerList.Sequence,
    DecisionMakerList.SeniorityLevel,
    ROW_NUMBER() OVER (PARTITION BY IndeedJobPost.Id ORDER BY DecisionMakerList.Sequence) rn INTO #Temp1
  FROM IndeedJobPost,
       DecisionMakerList
  WHERE (
  CHARINDEX(DecisionMakerList.Keyword + ' ', JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + ', ', JobTitle) > 0
  OR CHARINDEX(' ' + DecisionMakerList.Keyword, JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + '/', JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + '-', JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + ')', JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + '.', JobTitle) > 0
  OR CHARINDEX(DecisionMakerList.Keyword + ':', JobTitle) > 0
  OR CHARINDEX('(' + DecisionMakerList.Keyword, JobTitle) > 0
  OR CHARINDEX('/' + DecisionMakerList.Keyword, JobTitle) > 0
  OR CHARINDEX('-' + DecisionMakerList.Keyword, JobTitle) > 0
  OR CHARINDEX('.' + DecisionMakerList.Keyword, JobTitle) > 0
  OR REPLACE(DecisionMakerList.Keyword, ' ', '') = REPLACE(JobTitle, ' ', '')
  )
  AND DecisionMakerList.Sequence IS NOT NULL

  DELETE FROM #Temp1
  WHERE rn > 1

  UPDATE IndeedJobPost
  SET SeniorityLevel = (SELECT
    SeniorityLevel
  FROM #Temp1
  WHERE #Temp1.ID = IndeedJobPost.ID)
  UPDATE IndeedJobPost
  SET SeniorityLevel ='Others'
  WHERE SeniorityLevel is null

END
