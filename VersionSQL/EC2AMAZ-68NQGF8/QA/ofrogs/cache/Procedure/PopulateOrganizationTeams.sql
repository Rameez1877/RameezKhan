/****** Object:  Procedure [cache].[PopulateOrganizationTeams]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [cache].[PopulateOrganizationTeams]
/*
cache.PopulateOrganizationTeams
*/
AS
BEGIN
  SET NOCOUNT ON;

  CREATE TABLE #OrganizationTeams (
    OrganizationId int,
    CountryId int,
    TeamId int,
    TeamName varchar(200)
  )
  
	select t.Id, t.[Name], d.Keyword
	into #Teams
	from 
		McDecisionmaker d
		inner join Teams t on (t.[Name] = d.[Name])
	where
		Keyword <> ''

  INSERT INTO #OrganizationTeams (OrganizationId, CountryId, TeamId, TeamName)
    SELECT DISTINCT
      li.OrganizationId,
      li.ResultantCountryId,
      t.Id,
      t.[Name]
    FROM LinkedInData li
	INNER JOIN McDecisionmakerlist m on (li.Id = m.DecisionMakerId)
	INNER JOIN #Teams t ON (m.Name = t.Name)
	
  --  WHERE 
		--li.Designation IS NOT NULL
		--AND li.OrganizationId IS NOT NULL
		--AND li.ResultantCountryId IS NOT NULL

  INSERT INTO #OrganizationTeams (OrganizationId, CountryId, TeamId, TeamName)
    SELECT DISTINCT
      tag.OrganizationId,
      i.CountryCode,
      t.Id AS TeamId,
      t.[Name] AS TeamName
    FROM  IndeedJobPost i
	INNER JOIN JobPostExcellenceArea j ON (i.Id = j.JobPostId)
	INNER JOIN Tag tag ON (tag.Id = i.TagIdOrganization)
    INNER JOIN Teams t ON (t.Name = j.ExcellenceArea)
	
	--WHERE
	--	 li.ResultantCountryId IS NOT NULL

  INSERT INTO #OrganizationTeams (OrganizationId, CountryId, TeamId, TeamName)
    SELECT DISTINCT
      tag.OrganizationId,
      i.CountryCode,
      t.Id AS TeamId,
      t.[Name] AS TeamName
    FROM  IndeedJobPost i
	INNER JOIN JobPostSummaryExcellenceArea j ON (i.Id = j.JobPostId)
	INNER JOIN Tag tag ON (tag.Id = i.TagIdOrganization)
    INNER JOIN Teams t ON (t.Name = j.ExcellenceArea)
  

  TRUNCATE TABLE cache.OrganizationTeams
  INSERT INTO cache.OrganizationTeams (OrganizationId, CountryId, TeamId, TeamName)
    SELECT DISTINCT
      ot.OrganizationId,
      ot.CountryId,
      ot.TeamId,
      ot.TeamName
    FROM #OrganizationTeams ot
	where ot.CountryId is not null
	and ot.OrganizationId is not null
  DROP TABLE #OrganizationTeams
END
