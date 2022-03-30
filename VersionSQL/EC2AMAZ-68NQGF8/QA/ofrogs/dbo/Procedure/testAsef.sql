/****** Object:  Procedure [dbo].[testAsef]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[testAsef] @TargetPersonaId int
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      
-- [GetDecisionMakers] 1    
BEGIN
  DECLARE @AppRoleID int,
          @UserId int
  SELECT
    @UserId = CreatedBy
  FROM TargetPersona
  WHERE ID = @TargetPersonaId

  SELECT
    @AppRoleID = A.AppRoleID
  FROM AppUser A
  WHERE A.Id = @UserId

  IF @AppRoleID <> 3
    SELECT 
      li.Id,
      li.Gender,
      li.FirstName,
      li.LastName,
      li.[Name] + ', ' + li.Designation AS [Username],
      li.[Name],
      li.Designation,
      o.name AS Organization,
      li.EmailId,
      RTRIM(li.ResultantCountry) AS Country,
      li.[Url],
      v.FunctionalityDisplay AS [Functionality],
      li.SeniorityLevel,
      li.score,----??
      li.EmailVerificationStatus,---??
      o.Revenue,---??
      O.EmployeeCount,---??
      I.Name AS IndustryName,---??
      ls.TotalScore LeadScore--??
  FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml
      ON (li.Id = ml.DecisionMakerId
	 )
    INNER JOIN dbo.V_Functionality v
      ON (v.Functionality = ml.[Name])
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
	 LEFT OUTER JOIN Industry i
      ON (o.IndustryId = I.id)
  LEFT OUTER JOIN leadscore ls
      ON (ls.userid = @UserId
      AND ls.organizationid = o.id
      AND ls.type = 'Non App')
    WHERE ml.mode = 'Keyword Based List'
    AND li.[Url] <> ''
    AND T.OrganizationId IN (SELECT
      OrganizationId
    FROM TargetPersonaOrganization
    WHERE TargetPersonaId = @TargetPersonaId)
    AND (li.ResultantCountry) <> ''-- removal 12th nov removed rtrim
	AND  li.SeniorityLevel IN ('C-Level','Director')
	--and li.Functionality in ('account management', 'digital transformation','customer engagement')
	and li.country in ('india', 'united states of america')
	order by ls.TotalScore desc --??review order by
  ELSE

    SELECT TOP 500
      li.Id,
      li.Gender,
      li.FirstName,
      li.LastName,
      li.[Name] + ', ' + li.Designation AS [Username],
      li.[Name],
      li.Designation,
      o.name AS Organization,
      '**********' EmailId,-- email id hidden for demo account janna changed on 17th Oct 2019
      RTRIM(li.ResultantCountry) AS Country,
      li.[Url],
      v.FunctionalityDisplay AS [Functionality],
      li.SeniorityLevel,
      li.score,
      li.EmailVerificationStatus,
      o.Revenue,
      O.EmployeeCount,
      I.Name AS IndustryName,
      ls.TotalScore LeadScore
    FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml
      ON (li.Id = ml.DecisionMakerId)
    INNER JOIN dbo.V_Functionality v
      ON (v.Functionality = ml.[Name])
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
    LEFT OUTER JOIN Industry i
      ON (o.IndustryId = I.id)
    LEFT OUTER JOIN leadscore ls
      ON (ls.userid = @UserId
      AND ls.organizationid = o.id
      AND ls.type = 'Non App')
    WHERE ml.mode = 'Keyword Based List'
    AND li.[Url] <> ''
    AND T.OrganizationId IN (SELECT
      OrganizationId
    FROM TargetPersonaOrganization
    WHERE TargetPersonaId = @TargetPersonaId)
     AND (li.ResultantCountry) <> ''-- removal 12th nov removed rtrim
	order by ls.TotalScore desc
END
