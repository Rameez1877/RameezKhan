/****** Object:  Procedure [dbo].[sp_pop_lidata_aggression_level]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_pop_lidata_aggression_level

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  SELECT
    person_name,
    MAX(CountryOfOrigin) CountryOfOrigin INTO li_data_gender
  FROM person_gender
  WHERE CountryOfOrigin IS NOT NULL
  GROUP BY person_name


  UPDATE LinkedInData
  SET CountryOfOrigin
  = (SELECT
    CountryOfOrigin
  FROM li_data_gender li1
  WHERE li1.person_name = LinkedInData.firstname)
  WHERE firstname IN (SELECT
    person_name
  FROM li_data_gender)

  UPDATE linkedindata
  SET AggressionLevel = 'None'

  UPDATE linkedindata
  SET AggressionLevel = 'Aggressive'
  WHERE decisionmaker = 'DecisionMaker'
  AND Gender = 'M'
  AND
     CASE
       WHEN LEN(linkedin_country) > 0 THEN CASE
           WHEN linkedin_country = 'United States ' THEN 'United States Of America'
           ELSE SUBSTRING(linkedin_country, 1, LEN(linkedin_country) - 1)
         END
       ELSE ''
     END <> CountryOfOrigin
  AND LEN(CountryOfOrigin) > 2

  UPDATE linkedindata
  SET AggressionLevel = 'SuperAggressive'
  WHERE decisionmaker = 'DecisionMaker'
  AND Gender = 'F'
  AND
     CASE
       WHEN LEN(linkedin_country) > 0 THEN CASE
           WHEN linkedin_country = 'United States ' THEN 'United States Of America'
           ELSE SUBSTRING(linkedin_country, 1, LEN(linkedin_country) - 1)
         END
       ELSE ''
     END <> CountryOfOrigin
  AND LEN(CountryOfOrigin) > 2

  DROP TABLE li_data_gender
  --
  -- Based on Last Name, If Last Name is Found it has Country Different from linkedin_country then change  AggressionLevel
  --
  create table #LastName
  (Id int,
  Gender Varchar(1))

  insert into #LastName
  select id,gender from(
    select  li.id,
  li.gender,
  count(pn.country) all_country,
 sum(case when 
  CASE
       WHEN LEN(li.linkedin_country) > 0 THEN CASE
           WHEN li.linkedin_country = 'United States ' THEN 'United States Of America'
           ELSE SUBSTRING(li.linkedin_country, 1, LEN(li.linkedin_country) - 1)
         END
       ELSE ''
     END = Pn.Country then 1 else 0 end) this_country
	  from PersonLastName Pn, LinkedIndata Li
  where pn.lastname = li.lastname 
  and li.AggressionLevel = 'None'
  AND decisionmaker = 'DecisionMaker'
  	 group by li.id, li.gender)a
	 where this_country = 0

update linkedindata  
	  SET AggressionLevel = 'Aggressive'
  WHERE Gender = 'M'
  AND ID in(Select ID from #LastName)
  	 update linkedindata  
	  SET AggressionLevel = 'SuperAggressive'
  WHERE Gender = 'F'
  AND ID in(Select ID from #LastName)

  DROP TABLE #LastName
  END
