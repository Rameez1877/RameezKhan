/****** Object:  Procedure [dbo].[PopulateJobPostExcellenceAreaRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[PopulateJobPostExcellenceAreaRange]
@FromId int,
@ToId int

AS
BEGIN
	
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;
    DECLARE @StartTime datetime,
          @EndTime datetime
  Set 	@StartTime = GETDATE()	

  DELETE FROM JobPostExcellenceArea where JobPostID BETWEEN @FromId and @ToId
  SELECT
    A.id,
	t11.Name Marketinglist,
    t11.AliasName ExcellenceArea,
    t11.Keyword INTO #TempSummary
  FROM McDecisionMaker t11,
       IndeedJobPost A WITH (NOLOCK) 
  WHERE t11.IsOFList = 1
  AND ISactive = 1
  AND CHARINDEX(' ' + t11.keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A.Summary, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') + ' ') > 0
  AND t11.Name <> 'Others'
  and A.id BETWEEN @FromId and @ToId 

  SELECT
    A.id,
	t11.Name Marketinglist,
    t11.AliasName ExcellenceArea,
    t11.Keyword INTO #TempJobTitle
  FROM McDecisionMaker t11,
       IndeedJobPost A WITH (NOLOCK) 
  WHERE t11.IsOFList = 1
  AND ISactive = 1
  AND CHARINDEX(' ' + t11.keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A.JobTitle, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') + ' ') > 0
  AND t11.Name <> 'Others'
  and A.id BETWEEN @FromId and @ToId

  -- CREATE TABLE TempFinal
  CREATE TABLE #TempFinal (
  id INT, Marketinglist varchar(100), ExcellenceArea varchar(100), SummaryKeyword varchar(100), JobTitleKeyword varchar(100) )
 
  -- INTERSECTION OF BOTH TABLE
   INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t2.id, t2.Marketinglist, t2.ExcellenceArea, t2.Keyword, t3.Keyword
	  FROM #TempSummary t2, #TempJobTitle t3
	  WHERE t2.id = t3.id
	  and t2.Marketinglist = t3.Marketinglist

 -- MARKETING LIST AND ID ARE NOT MATCHING IN BOTH THE TABLE, PUSH THOSE RECORDS INDIVIDUALLY TO THE TABLE 
  INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t3.id, t3.Marketinglist, t3.ExcellenceArea, NULL, t3.Keyword as JobTitleKeyword
	  FROM #TempJobTitle t3
	  WHERE not exists (SELECT * FROM #TempFinal WHERE #TempFinal.id = t3.id AND #TempFinal.Marketinglist = t3.Marketinglist)

  INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t3.id, t3.Marketinglist, t3.ExcellenceArea, t3.Keyword , NULL 
	  FROM #TempSummary t3
	  WHERE not exists (SELECT * FROM #TempFinal WHERE #TempFinal.id = t3.id AND #TempFinal.Marketinglist = t3.Marketinglist)

 
  INSERT INTO JobPostExcellenceArea (JobPostID,
  Marketinglist,
  ExcellenceArea,
  Keyword, 
  JobTitleKeyword)

    SELECT
      t1.ID,
	  t1.Marketinglist,
      T1.ExcellenceArea, 
      REPLACE((SELECT
        SummaryKeyword+'|' AS [data()]
      FROM #TempFinal t2
      WHERE t2.id = t1.id
      AND t2.ExcellenceArea = t1.ExcellenceArea
      ORDER BY SummaryKeyword
      FOR xml PATH ('')), '|', ','),
	  REPLACE((SELECT
        JobTitleKeyword +'|' AS [data()]
      FROM #TempFinal t2
      WHERE t2.id = t1.id
      AND t2.ExcellenceArea = t1.ExcellenceArea
      ORDER BY JobTitleKeyword
      FOR xml PATH ('')), '|', ',')
    FROM #TempFinal t1
    GROUP BY t1.ID,
             t1.Marketinglist, T1.ExcellenceArea;

  INSERT INTO JobPostExcellenceArea (JobPostId,
  Marketinglist,
  ExcellenceArea)
    SELECT
      A.id,
	  'Others' AS Marketinglist,
      'Others' AS ExcellenceArea
    FROM IndeedJobPost A WITH (NOLOCK)
    WHERE 
	id BETWEEN @FromId and @ToId
	and NOT EXISTS (SELECT
      *
    FROM JobPostExcellenceArea AAE
    WHERE AAE.JobPostId = A.ID)
	
	Update JobPostExcellenceArea SET keyword =SUBSTRING(keyword,1,len(keyword)-1)
	WHERE CHARINDEX(',',keyword) > 0 AND JobPostID BETWEEN @FromId and @ToId

	UPDATE IndeedJobPost SET IsLabelled =1 
    WHERE id BETWEEN @FromId and @ToId
	 Set 	@EndTime = GETDATE()	
	INSERT INTO JobStatusLog --
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('PopulateJobPostExcellenceAreaRange',--
      @StartTime,--
      @EndTime,--
      'JobPost Labelling Completed')
END
