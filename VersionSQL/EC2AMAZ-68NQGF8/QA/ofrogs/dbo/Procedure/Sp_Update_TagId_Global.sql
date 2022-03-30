/****** Object:  Procedure [dbo].[Sp_Update_TagId_Global]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Update_TagId_Global]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select id as Tagid,
Name,
REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(name,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  ' ',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company',''),
  ',',''),
  '''',''),
  '/','')
  AS newname into #tempTag from tag
  where tagtypeid=1

update technographics set TagIdOrganization = 
(select id from tag  where tag.name collate SQL_Latin1_General_CP1_CI_AS= technographics.companyname
and tagtypeid = 1)  
where TagIdOrganization is null


--TagID in Technographics Table -- InDirect Match Starts
SELECT Id As TechnographicsID,
  CompanyName,
  REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE( REPLACE( 
  REPLACE(replace(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(companyname,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  ' ',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company',''),
  ',',''),
  '''',''),
  '/','')
  AS neworg into #TempTechnographics
FROM Technographics
WHERE tagidorganization is null

  select TechnographicsID,
  Tagid 
  into #TempLiFinalTechnographics
  from #TempTechnographics li,  #tempTag t
  where t.newname collate SQL_Latin1_General_CP1_CI_AS = li.neworg

  ;WITH CTE AS(
   SELECT TechnographicsID,
       RN = ROW_NUMBER()OVER(PARTITION BY TechnographicsID ORDER BY Tagid)
   FROM #TempLiFinalTechnographics
)
DELETE FROM CTE WHERE RN > 1

  Update Technographics 
  set TagidOrganization =(select tagid from #TempLiFinalTechnographics
  WHERE #TempLiFinalTechnographics.TechnographicsID = Technographics.ID)
  WHERE Tagid is null
  and ID in (SELECT TechnographicsID FROM #TempLiFinalTechnographics)

-- TagID in LinkedinData Table -- Direct Match Starts

create table #temp1(linkedinid int, tagid int)

insert into #temp1
select li.id linkedinid, t.id as tagid  from linkedindata li, tag t
where li.tagid=0
and li.organization  = t.name collate SQL_Latin1_General_CP1_CI_AS
and t.tagtypeid=1

update linkedindata set tagid = 
(select tagid from #temp1 where #temp1.linkedinid = linkedindata.id)
where  id in (select linkedinid from #temp1)
and tagid=0

--TagID in LinkedinData Table -- Direct Match Ends

-- TagID in LinkedinData Table -- InDirect Match Starts
SELECT Id As LinkedInDataID,
  organization,
  REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(replace(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(organization,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  ' ',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company',''),
  ',',''),
  '''',''),
  '/','')
  AS neworg into #TempLinkedInData
FROM linkedindata
WHERE tagid = 0
and organization not in ('','NA','Self Employed','Self-Employed','Founder')


 
  select LinkedInDataID,
  Tagid 
  into #TempLiFinal
  from #TempLinkedInData li,  #tempTag t
  where t.newname collate SQL_Latin1_General_CP1_CI_AS = li.neworg

  ;WITH CTE AS(
   SELECT LinkedInDataID,
       RN = ROW_NUMBER()OVER(PARTITION BY LinkedInDataID ORDER BY Tagid)
   FROM #TempLiFinal
)
DELETE FROM CTE WHERE RN > 1

  Update LinkedInData 
  set Tagid =(select tagid from #TempLiFinal
  WHERE #TempLiFinal.LinkedInDataID = LinkedInData.ID)
  WHERE Tagid = 0
  and ID in (SELECT LinkedInDataID FROM #TempLiFinal)
  --TagID in LinkedinData Table -- InDirect Match Ends

  
----TagID in Awards Table -- InDirect Match Starts
SELECT Id As AwardID,
  organization,
  REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(replace(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE( REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(organization,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  ' ',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company',''),
  ',',''),
  '''',''),
  '/','')
  AS neworg into #TempAwards
FROM Awards
WHERE tagid is null


  select AwardID,
  Tagid 
  into #TempLiFinalAwards
  from #TempAwards li,  #tempTag t
  where t.newname collate SQL_Latin1_General_CP1_CI_AS = li.neworg

  ;WITH CTE AS(
   SELECT AwardID,
       RN = ROW_NUMBER()OVER(PARTITION BY AwardID ORDER BY Tagid)
   FROM #TempLiFinalAwards
)
DELETE FROM CTE WHERE RN > 1

  Update Awards 
  set Tagid =(select tagid from #TempLiFinalAwards
  WHERE #TempLiFinalAwards.AwardID = Awards.ID)
  WHERE Tagid is null
  and ID in (SELECT AwardID FROM #TempLiFinalAwards)

   Update Awards 
   Set Of_OrganizationID = (select OrganizationId from Tag 
   where tag.id=Awards.TagID)

  --TagID in Awards Table -- InDirect Match Ends

  -- indeedjobpost starts

  

  SELECT Id As JobPostID,
  companyname,
  REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(replace(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(
  REPLACE( REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(  REPLACE(
  REPLACE(companyname,
   ' Company Ltd', ''),
 ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"',''),
  ' Co, Ltd',''),
  ', Ltd',''),
  ' Ltd',''),
  ' ',''),
  '&','and'),
  '®',''),
  ', Inc',''),
  ' plc',''),
  ', L.P.',''),
  ', a GE company',''),
  ',',''),
  '''',''),
  '/','')
  AS neworg into #TempJobPost
FROM indeedjobpost where tagidorganization is null

 select JobPostID,
  Tagid 
  into #TempLiFinalJobPost
  from #TempJobPost li,  #tempTag t
  where t.newname collate SQL_Latin1_General_CP1_CI_AS = li.neworg


  ;WITH CTE AS(
   SELECT JobPostID,
       RN = ROW_NUMBER()OVER(PARTITION BY JobPostID ORDER BY Tagid)
   FROM #TempLiFinalJobPost
)
DELETE FROM CTE WHERE RN > 1

  Update indeedjobpost 
  set tagidorganization =(select tagid from #TempLiFinalJobPost
  WHERE #TempLiFinalJobPost.JobPostID = indeedjobpost.ID)
  WHERE tagidorganization is null
  and ID in (SELECT JobPostID FROM #TempLiFinalJobPost)
  
  drop table #temp1
  drop table #tempTag
  drop table #TempTechnographics
  drop table #TempLiFinalTechnographics
  drop table #TempLinkedInData
  drop table #TempLiFinal
  drop table #TempAwards
  DROP table #TempLiFinalJobPost
  DROP TABLE #TempJobPost

END
