/****** Object:  Procedure [dbo].[PopulateTechnoGraphicsCRMDataTagType25]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Janna
-- Create date: 29-Aug-2019
-- Description:	Temporary Procedure for getting CRM Data from TechnoGraphics For TagTypeId = 25
-- =============================================
CREATE PROCEDURE [dbo].[PopulateTechnoGraphicsCRMDataTagType25]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	create Table #TempTag(TagID Int)

	Insert Into #TempTag
	Select id FROM tag where tagtypeid=25 
   and name collate SQL_Latin1_General_CP1_CI_AS in 
   (select CrmSoftware from v_CrmSoftware where CRMSoftware like '%Hub%')

  --Insert into #TempTag
  --Values (15304)--SugarCRM

  SELECT * Into #TempTechnographics from Technographics
  where len(keyword) > 2
  AND tagid in (select Tagid from #TempTag)

  SELECT IND.* INTO #TempIndeedJobPost 
  from IndeedJobPost Ind
  WHERE Ind.TagTypeID = 25
  AND Ind.CountryCode is not null
  AND EXISTS
  (select * from #TempTechnographics TT
  WHERE TT.CompanyName = Ind.CompanyName
  And Tt.Keyword = Ind.keyword
  And TT.CountryID = Ind.CountryCode
  AND Tt.TagId = Ind.TagID)
  
 Select T1.Keyword, T1.CompanyName, T1.URL, T1.Location, C.name As Country From 
 #TempIndeedJobPost T1, Country C
 WHERE C.id = t1.CountryCode
 order by Keyword, CompanyName, URL

  DROP TABLE #TempIndeedJobPost
  DROP TABLE #TempTag
  DROP TABLE #TempTechnographics


end
