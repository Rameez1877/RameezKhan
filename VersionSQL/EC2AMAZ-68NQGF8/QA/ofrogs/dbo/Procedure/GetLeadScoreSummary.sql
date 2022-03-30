/****** Object:  Procedure [dbo].[GetLeadScoreSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      Asef Daqiq
-- Create date: 3 Aug, 2021
-- Description:	Gets the user settings fro LeadScore Configuration screen.//
-- =============================================
CREATE PROCEDURE [dbo].[GetLeadScoreSummary] @TargetPersonaId int, @PersonaType varchar(100)
AS
/*
[dbo].[GetLeadScoreSummary]  21031, 'cloud persona'
*/
BEGIN
  SET NOCOUNT ON;
  DECLARE @UserId int

  SELECT
    @UserId = CreatedBy
  FROM TargetPersona
  WHERE Id = @TargetPersonaId

  SELECT DISTINCT
    i.id,
    i.[Name],
	i.IndustryGroup,
	i.IndustryGroupId
	INTO #industry
  FROM TargetPersonaOrganization t
  INNER JOIN organization o
    ON (t.OrganizationId = o.Id
    AND t.TargetPersonaId = @TargetPersonaId)
  INNER JOIN Industry i
    ON i.Id = o.IndustryId


  SELECT
    'Functionality' AS [FilterType],
    0 AS Id,
    a.Category as CategoryName,
    A.Functionality [Name],
    ISNULL(u.ApplyScore, 0) as ApplyScore,
    0 AS IndustryGroupId
  FROM AdoptionFramework A
  LEFT JOIN UserTargetFunctionality U
    ON (a.Functionality = u.Functionality
    AND TargetPersonaId = @TargetPersonaId)
  WHERE A.Category = @PersonaType
  UNION
  SELECT
    'Technology',
    0 AS Id,
    A.TechnologyCategory AS CategoryName,
    TST.StackTechnologyName AS Technology,
    ISNULL(UTF.ApplyScore, 0) as ApplyScore,
    0 AS IndustryGroupId
  FROM AdoptionFrameworkTechnologyCategory A
  INNER JOIN TechStackTechnology TST
    ON TST.StackSubCategoryId = A.TechnologyCategoryId
  LEFT JOIN UserTargetTechnology UTF
    ON (TST.StackTechnologyName = UTF.Technology
     AND TargetPersonaId = @TargetPersonaId)
  WHERE A.Category = @PersonaType
  UNION
  SELECT
    'Industry',
    i.Id AS Id,
    I.IndustryGroup AS CategoryName,
    I.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS,
    ISNULL(uti.ApplyScore, 0) as ApplyScore,
    I.IndustryGroupId
  FROM #industry i
  LEFT JOIN UserTargetIndustry uti
    ON (i.Id = uti.IndustryId
    AND TargetPersonaId = @TargetPersonaId)
  ORDER BY FilterType, CategoryName

END
