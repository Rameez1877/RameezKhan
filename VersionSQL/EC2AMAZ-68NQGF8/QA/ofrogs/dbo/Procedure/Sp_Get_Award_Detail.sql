/****** Object:  Procedure [dbo].[Sp_Get_Award_Detail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Get_Award_Detail] @OrganizationID int
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  --;
  --WITH cte
  --AS (SELECT
  --  t2.AwardID ID,
  --  STUFF((SELECT
  --    ',' + ExcellenceArea
  --  FROM AwardExcellenceArea t1
  --  WHERE t1.AwardID = t2.AwardID
  --  FOR xml PATH ('')), 1, 1, '') ExcellenceArea
  --FROM AwardExcellenceArea t2
  --GROUP BY t2.AwardID)
  SELECT
    o.name AS CompanayName,
    A.Entry_Title,
    --A.Excellence_In_Program_Area,
    AEA.ExcellenceArea Excellence_In_Program_Area,
    Title,
    Year,
    Source_Website_URL
  FROM Awards A with (NOLOCK),
       Organization O with (NOLOCK),
       AwardExcellenceArea AEA with (NOLOCK)
  WHERE A.Type = 'O'
  AND A.OF_OrganizationID = O.id
  AND A.ID = AEA.AwardID
  AND O.id = @OrganizationID
  AND year >= DATEPART(yyyy, GETDATE()) - 1-- Only two years of data to be shown, not old awards
  ORDER BY Year Desc
END
