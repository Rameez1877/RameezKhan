/****** Object:  Procedure [dbo].[PopulateTechnoGraphicsCRMDataTagTypeOthers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Janna
-- Create date: 29-Aug-2019
-- Description:	Temporary Procedure for getting CRM Data from TechnoGraphics For TagTypeId <> 25
-- =============================================
CREATE PROCEDURE [dbo].[PopulateTechnoGraphicsCRMDataTagTypeOthers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	-- TagID for CRM Software
	CREATE Table #TempTag(TagID Int, Name VARCHAR(500))

	Insert Into #TempTag
	Select id,name FROM tag where tagtypeid=25 
   and name collate SQL_Latin1_General_CP1_CI_AS in 
   (select CrmSoftware from v_CrmSoftware where CRMSoftware like '%Hub%')

   -- All technographics Data for CRM Software
   SELECT * Into #TempTechnographics from Technographics
  where len(keyword) > 2
  AND tagid in (select Tagid from #TempTag)
  --
  -- Jobposts for TagTypeID = 25
  --
  SELECT IND.* INTO #TempIndeedJobPost25 
  from IndeedJobPost Ind
  WHERE Ind.TagTypeID = 25
  AND Ind.CountryCode is not null
  AND EXISTS
  (select * from #TempTechnographics TT
  WHERE TT.CompanyName = Ind.CompanyName
  And Tt.Keyword = Ind.keyword
  And TT.CountryID = Ind.CountryCode
  AND Tt.TagId = Ind.TagID)
  

  SELECT IND.* INTO #TempIndeedJobPost 
  from IndeedJobPost Ind
  WHERE Ind.TagTypeID <> 25
  AND Ind.CountryCode is not null
  and len(url) > 5
  AND EXISTS
  (select * from #TempTechnographics TT
  WHERE TT.CompanyName = Ind.CompanyName
  And Tt.Keyword = Ind.keyword
  And TT.CountryID = Ind.CountryCode
  AND Tt.TagId = Ind.TagID)
  AND IND.ID Not in (SELECT ID FROM #TempIndeedJobPost25)-- Exclude Jobposts that participated in TagtYpeId=25
 
 --
 --
 --
  create table #TempIndeedJobPostnew(
  keyword varchar(100),
  companyname varchar(500),
  url varchar(4000),
  location varchar(4000),
  Country varchar(500))
  
 declare @Tagid INT ,@TagName varchar(500)
 DECLARE db_cursor1 CURSOR FOR 
 SELECT Tagid,Name  from #TempTag
 Open db_cursor1
 Fetch db_cursor1 INTO @Tagid,@TagName
 WHILE @@FETCH_STATUS = 0  
BEGIN 

INSERT INTO #TempIndeedJobPostnew
Select t.name as keyword,i.companyname, i.url, i.location,c.name as Country
  From #TempIndeedJobPost i, #TempTag t, Country C
 WHERE c.id= i.CountryCode 
 and t.tagid = @Tagid
 and (CHARINDEX(' ' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ' ', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ', ', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '/', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '-', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ')', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '.', summary) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ':', summary) >0 OR
 CHARINDEX('(' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, summary) >0 OR
  CHARINDEX('/' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, summary) >0 OR
 CHARINDEX('-' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, summary) >0 OR
 CHARINDEX('.' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, summary) >0 OR
 CASE
       WHEN REPLACE(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS, ' ', '') = REPLACE(summary, ' ', '') THEN 1
       ELSE 0
     END = 1 or 
  CASE
       WHEN summary COLLATE Latin1_General_CI_AI LIKE '% ' + @tagName THEN 1
       ELSE 0
     END = 1	  or
  CASE
       WHEN summary COLLATE Latin1_General_CI_AI LIKE @tagName + ' %' THEN 1
       ELSE 0
     END = 1 or
	 CHARINDEX(' ' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ' ', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ', ', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '/', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '-', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ')', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + '.', JobTitle) >0 OR
 CHARINDEX(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS + ':', JobTitle) >0 OR
 CHARINDEX('(' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) >0 OR
  CHARINDEX('/' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) >0 OR
 CHARINDEX('-' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) >0 OR
 CHARINDEX('.' + @tagName COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) >0 OR
 CASE
       WHEN REPLACE(@tagName COLLATE SQL_Latin1_General_CP1_CI_AS, ' ', '') = REPLACE(JobTitle, ' ', '') THEN 1
       ELSE 0
     END = 1 or 

  CASE
       WHEN JobTitle COLLATE Latin1_General_CI_AI LIKE '% ' + @tagName THEN 1
       ELSE 0
     END = 1	  or
  CASE
       WHEN JobTitle COLLATE Latin1_General_CI_AI LIKE @tagName + ' %' THEN 1
       ELSE 0
     END = 1)
	  Fetch db_cursor1 INTO @Tagid,@TagName
	 END 
---
	  
  SELECT * From #TempIndeedJobPostnew order by Keyword, CompanyName, URL

  DROP TABLE #TempIndeedJobPost
  DROP TABLE #TempTag
  DROP TABLE #TempTechnographics
  DROP TABLE #TempIndeedJobPost25
  DROP TABLE #TempIndeedJobPostnew
  CLOSE db_cursor1  
  DEALLOCATE db_cursor1 
end
