/****** Object:  Procedure [dbo].[PopulateAwardExcellenceAreaRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].PopulateAwardExcellenceAreaRange
-- Add the parameters for the stored procedure here  
@FromAwardID INT,
@ToAwardID INT
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;

  DELETE FROM AwardExcellenceArea WHERE AwardID Between @FromAwardID AND @ToAwardID

  SELECT
    A.id,
    t11.AliasName ExcellenceArea,
    t11.Keyword INTO #Temp1
  FROM McDecisionMaker t11,
       Awards A
  WHERE t11.IsOFList = 1
  AND ISactive = 1
  AND CHARINDEX(' ' + t11.keyword + ' ', ' ' + A.Title + ' ') > 0
  AND t11.Name <> 'Others'
  AND A.ID Between @FromAwardID AND @ToAwardID

  INSERT INTO AwardExcellenceArea (AwardID,
  ExcellenceArea,
  Keyword)
    SELECT
      t1.ID,
      T1.ExcellenceArea,
      REPLACE((SELECT
        Keyword+'|' AS [data()]
      FROM #Temp1 t2
      WHERE t2.id = t1.id
      AND t2.ExcellenceArea = t1.ExcellenceArea
      ORDER BY Keyword
      FOR xml PATH ('')), '|', ',')
    FROM #Temp1 t1
    GROUP BY t1.ID,
             T1.ExcellenceArea;

  INSERT INTO AwardExcellenceArea (AwardID,
  ExcellenceArea)
    SELECT
      A.id,
      'Others' AS ExcellenceArea
    FROM Awards A
    WHERE NOT EXISTS (SELECT
      *
    FROM AwardExcellenceArea AAE
    WHERE AAE.AwardId = A.ID)
	AND A.ID Between @FromAwardID AND @ToAwardID

	Update AwardExcellenceArea SET keyword =SUBSTRING(keyword,1,len(keyword)-1)
	WHERE CHARINDEX(',',keyword)>0 
	AND AwardID Between @FromAwardID AND @ToAwardID
END
