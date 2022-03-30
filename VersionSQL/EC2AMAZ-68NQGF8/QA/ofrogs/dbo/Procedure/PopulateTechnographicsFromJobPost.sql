/****** Object:  Procedure [dbo].[PopulateTechnographicsFromJobPost]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateTechnographicsFromJobPost]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  
  -- Insert statements for procedure here
  
  SELECT
    * INTO #Temp1
  FROM tag
  WHERE tagtypeid = 25
  SELECT top 1000
    * INTO #Temp2
  FROM indeedjobpost WITH (NOLOCK) 
  WHERE IsTechnoGraphicsProcessed ='N'
  and CountryCode is not null
 

  CREATE TABLE #Temp3 (
    keyword varchar(100),
    CompanyName varchar(100),
    CountryID int,
    TagId int,
    IsExists bit DEFAULT 0,
    Summary varchar(4000),
    JobTitle varchar(4000),
	TagIdOrganization INT
  )
  INSERT INTO #Temp3 (keyword, CompanyName, CountryID, TagId, Summary, JobTitle)
    SELECT
      t.name AS keyword,
      ind.CompanyName,
      ind.CountryCode CountryID,
      T.id TagId,
      Substring(ind.Summary,1,4000),
      ind.JobTitle
    FROM #Temp2 ind,
         #Temp1 t
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(' ' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ' ', summary) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ', ', summary) > 0
 
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '/', summary) > 0
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '-', summary) > 0
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ')', summary) > 0
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '.', summary) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ':', summary) > 0
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('(' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, summary) > 0
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('/' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, summary) > 0
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('-' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, summary) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('.' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, summary) > 0
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN REPLACE(keyword COLLATE SQL_Latin1_General_CP1_CI_AS, ' ', '') = REPLACE(summary, ' ', '') THEN 1
       ELSE 0
     END = 1
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN summary COLLATE Latin1_General_CI_AI LIKE '% ' + keyword THEN 1
       ELSE 0
     END = 1
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN summary COLLATE Latin1_General_CI_AI LIKE keyword + ' %' THEN 1
       ELSE 0
     END = 1
  --
 
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(' ' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ' ', JobTitle) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ', ', JobTitle) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '/', JobTitle) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '-', JobTitle) > 0
 
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ')', JobTitle) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + '.', JobTitle) > 0
  
  UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX(keyword COLLATE SQL_Latin1_General_CP1_CI_AS + ':', JobTitle) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('(' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) > 0
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('/' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('-' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND CHARINDEX('.' + keyword COLLATE SQL_Latin1_General_CP1_CI_AS, JobTitle) > 0
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN REPLACE(keyword COLLATE SQL_Latin1_General_CP1_CI_AS, ' ', '') = REPLACE(JobTitle, ' ', '') THEN 1
       ELSE 0
     END = 1
   UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN JobTitle COLLATE Latin1_General_CI_AI LIKE '% ' + keyword THEN 1
       ELSE 0
     END = 1
 UPDATE #Temp3
  SET IsExists = 1
  WHERE IsExists = 0
  AND
     CASE
       WHEN JobTitle COLLATE Latin1_General_CI_AI LIKE keyword + ' %' THEN 1
       ELSE 0
     END = 1
  
;WITH CTE AS(
   SELECT Keyword,CompanyName,TagID,CountryID,
        ROW_NUMBER()OVER(PARTITION BY Keyword,CompanyName,TagID,CountryID 
		ORDER BY Keyword,CompanyName,TagID,CountryID) rn
   FROM #TEMP3
)
DELETE FROM CTE WHERE RN > 1

 delete FROM #TEMP3 WHERE 
    exists
  (select * from technographics tech
  where tech.keyword collate  Latin1_General_CI_AI = #TEMP3.keyword
  and  tech.companyname collate Latin1_General_CI_AI = #TEMP3.CompanyName
  and tech.CountryID  = #TEMP3.CountryID
 and tech.tagid=  #TEMP3.tagid )
  --
  --TagID starts
  --
  create table #TempTechTag(
  companyname varchar(500), tagid int)
  insert into #TempTechTag(companyname,tagid)
  select tech.companyname, tag.id as tagid  from #temp3 tech, tag
where len(keyword) > 2 
and tag.Name collate SQL_Latin1_General_CP1_CI_AS = tech.CompanyName
and tag.TagTypeId= 1
group by tech.companyname,tag.id

update #temp3 set TagIdOrganization=(select tagid from #TempTechTag tt
where tt.companyname= #temp3.CompanyName)

-- TagiD ends

insert into Technographics (keyword,InsertedDate,companyname,CountryID,TagID,TagIdOrganization)
select keyword,getdate(),companyname,CountryID,TagID,TagIdOrganization from #TEMP3
WHERE IsExists = 1
 
Update  indeedjobpost set IsTechnoGraphicsProcessed='Y'
WHERE ID in (SELECT ID from #Temp2)

DROP TABLE #Temp1
DROP TABLE #Temp2
DROP TABLE #Temp3
DROP TABLE #TempTechTag

END
