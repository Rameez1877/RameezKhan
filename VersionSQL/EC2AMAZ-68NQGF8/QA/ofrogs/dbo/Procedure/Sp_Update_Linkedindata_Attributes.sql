/****** Object:  Procedure [dbo].[Sp_Update_Linkedindata_Attributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Update_Lidata_Motivation_EducationLevel]
AS
BEGIN
 
  SET NOCOUNT ON;

  SELECT
    id,
    v.EducationLevelDisplay EducationLevel,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY v.sequence) AS rnum INTO #TempLiData
  FROM linkedindata li,
       V_Education_Level v
  WHERE CHARINDEX(v.EducationLevel, summary) > 0

  DELETE FROM #TempLiData
  WHERE rnum <> 1

  UPDATE linkedindata
  SET EducationLevel = (SELECT
    EducationLevel
  FROM #TempLiData
  WHERE #TempLiData.ID = linkedindata.ID)

  UPDATE Linkedindata
  SET Motivation = 'Y'
  WHERE EXISTS (SELECT
    *
  FROM v_motivation
  WHERE CHARINDEX(motivation, designation) > 0)
  

  select li.id, max(p.ethnicity) ethnicity  into #tempethnicity 
  from linkedindata li, personethnicity p
where li.countryoforigin =p.country
and li.lastname=p.lastname
group by li.id

select * from #tempethnicity

update linkedindata set ethnicity =(select t1.ethnicity from #tempethnicity t1
where  t1.id = linkedindata.id)
WHERE id in (select id from #tempethnicity)


END
