/****** Object:  Procedure [cache].[PopulateDecisionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    <AuthorName>
-- Create date: <Create Date>
-- Description:  <Description>
-- =============================================
CREATE PROCEDURE [cache].[PopulateDecisionMakers]
/*
[cache].[PopulateDecisionMakers]
*/
AS
BEGIN
  SET NOCOUNT ON;

  SELECT
    li.[Id],
    li.[Name],
    li.[Url],
    li.[OrganizationId],
    o.[Name] AS OrganizationName,
    li.[Designation],
    --(select STRING_AGG(MD.[Name], ', ') from McDecisionMakerList MD where MD.DecisionMakerId = [Id])[Functionality],
    li.[ResultantCountryId],
    c.[Name] AS CountryName,
    li.[IndustryId],
    i.[Name] AS IndustryName,
    [SeniorityLevel],
    [FirstName],
    [MiddleName],
    [LastName],
    [firstsuggested_domainname],
    [LastUpdatedOn],
    [Gender],
    [TagId],
    [IsNewHire],
    [IsChampion] INTO #tempLinkedInData
  FROM LinkedInData li WITH (NOLOCK)
  LEFT JOIN Country c
    ON (c.Id = li.ResultantCountryId)
  LEFT JOIN Industry i
    ON (i.Id = li.IndustryId)
  LEFT JOIN Organization o
    ON (o.Id = li.OrganizationId)
  WHERE SeniorityLevel IN ('C-Level', 'Director', 'Influencer')
  AND OrganizationId <> 0

  -- SELECT DISTINCT
  --  MC.DecisionMakerId,
  --  MC.[Name]
  --INTO #DecisionMakers 
  --FROM dbo.McDecisionmakerlist MC
  --INNER JOIN #tempLinkedInData temp
  --  ON (temp.id = MC.DecisionMakerId)

  --BEGIN TRAN
    TRUNCATE TABLE [cache].[DecisionMakers]
    SET IDENTITY_INSERT [cache].[DecisionMakers] ON

    INSERT INTO [cache].[DecisionMakers] ([Id],
    [Name],
    [Url],
    [OrganizationId],
    [OrganizationName],
    [Designation],
    [Functionality],
    [CountryId],
    [CountryName],
    [IndustryId],
    [IndustryName],
    [SeniorityLevel],
    [FirstName],
    [MiddleName],
    [LastName],
    [FirstSuggestedDomain],
    [LastUpdatedOn],
    [Gender],
    [TagId],
    [IsNewHire],
    [IsChampion])
      SELECT 
        li.[Id],
        li.[Name],
        li.[Url],
        li.[OrganizationId],
        li.OrganizationName,
        li.[Designation],
        --(select STRING_AGG(MD.[Name], ', ') from McDecisionMakerList MD where MD.DecisionMakerId = [Id])[Functionality],
        -- dm.Names AS Functionality,
        --REPLACE
        --(REPLACE
        --(STUFF
        --((SELECT
        --  ', ' + [Name]
        --FROM (SELECT DISTINCT
        --  [Name]
        --FROM #DecisionMakers D
        --WHERE D.decisionmakerid = li.Id) mc2
        --FOR xml PATH ('')), 1, 1, ''), '&amp;', '&'), '''', '') AS Functionality,
		'' AS Functionality,
        li.[ResultantCountryId],
        li.CountryName,
        li.[IndustryId],
        li.IndustryName,
        [SeniorityLevel],
        [FirstName],
        [MiddleName],
        [LastName],
        [firstsuggested_domainname],
        [LastUpdatedOn],
        [Gender],
        [TagId],
        [IsNewHire],
        [IsChampion]
      FROM #tempLinkedInData li

	    truncate table cache.DecisionMakerFunctionality

		Insert INTO cache.DecisionMakerFunctionality
		SELECT DISTINCT
		MC.DecisionMakerId,
		MC.[Name]
		FROM dbo.McDecisionmakerlist MC
		INNER JOIN cache.DecisionMakers temp
		ON (temp.id = MC.DecisionMakerId)
		WHERE
		MC.Mode = 'Keyword Based List'

  --COMMIT


  SET IDENTITY_INSERT [cache].[DecisionMakers] OFF

END
