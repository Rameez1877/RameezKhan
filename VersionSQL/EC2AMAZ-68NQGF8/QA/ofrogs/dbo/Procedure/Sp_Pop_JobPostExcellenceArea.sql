/****** Object:  Procedure [dbo].[Sp_Pop_JobPostExcellenceArea]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_Pop_JobPostExcellenceArea]
-- Add the parameters for the stored procedure here  
AS
BEGIN
	
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;

  DELETE FROM JobPostExcellenceArea
  print 'before Summary'
  print getdate()
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

  print 'before Jobtitle'
  print getdate()
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

  -- CREATE TABLE TempFinal
  CREATE TABLE #TempFinal (
  id INT, Marketinglist varchar(100), ExcellenceArea varchar(100), SummaryKeyword varchar(100), JobTitleKeyword varchar(100) )
 
  print 'before Final'
  print getdate()
   -- INTERSECTION OF BOTH TABLE
   INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t2.id, t2.Marketinglist, t2.ExcellenceArea, t2.Keyword, t3.Keyword
	  FROM #TempSummary t2, #TempJobTitle t3
	  WHERE t2.id = t3.id
	  and t2.Marketinglist = t3.Marketinglist

  print 'before Final itersection'
  print getdate()
  -- MARKETING LIST AND ID ARE NOT MATCHING IN BOTH THE TABLE, PUSH THOSE RECORDS INDIVIDUALLY TO THE TABLE 
  INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t3.id, t3.Marketinglist, t3.ExcellenceArea, NULL, t3.Keyword as JobTitleKeyword
	  FROM #TempJobTitle t3
	  WHERE not exists (SELECT * FROM #TempFinal WHERE #TempFinal.id = t3.id AND #TempFinal.Marketinglist = t3.Marketinglist)

  INSERT INTO #TempFinal (id, Marketinglist, ExcellenceArea, SummaryKeyword, JobTitleKeyword)
	  SELECT t3.id, t3.Marketinglist, t3.ExcellenceArea, t3.Keyword , NULL 
	  FROM #TempSummary t3
	  WHERE not exists (SELECT * FROM #TempFinal WHERE #TempFinal.id = t3.id AND #TempFinal.Marketinglist = t3.Marketinglist)

  print 'before JobPostExcellenceArea'
  print getdate()

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
    WHERE NOT EXISTS (SELECT
      *
    FROM JobPostExcellenceArea AAE
    WHERE AAE.JobPostId = A.ID)

	Update JobPostExcellenceArea SET keyword =SUBSTRING(keyword,1,len(keyword)-1)
	WHERE CHARINDEX(',',keyword)>0 
    Update JobPostExcellenceArea SET JobTitleKeyword =SUBSTRING(JobTitleKeyword,1,len(JobTitleKeyword)-1)
	WHERE CHARINDEX(',',JobTitleKeyword)>0 

END
