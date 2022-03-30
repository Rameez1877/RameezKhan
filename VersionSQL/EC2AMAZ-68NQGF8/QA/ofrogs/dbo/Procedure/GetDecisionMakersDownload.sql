/****** Object:  Procedure [dbo].[GetDecisionMakersDownload]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersDownload] @TargetPersonaId int
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      
-- [[GetDecisionMakersDownload]] 1    
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
      li.ResultantCountry AS Country,
      li.[Url],
      ml.name AS [Functionality],
      li.SeniorityLevel,
	  o.Revenue,
      o.EmployeeCount,
      I.Name AS IndustryName
    FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml
      ON (li.Id = ml.DecisionMakerId)
    --INNER JOIN dbo.V_Functionality v
    --  ON (v.Functionality = ml.[Name])
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
  -- AND li.SeniorityLevel IN ('C-Level', 'Director')
  AND  li.SeniorityLevel IN (select seniority from UserTargetSeniority where userid=@UserId)
    AND (li.ResultantCountry) IN (SELECT
      Name
    FROM UserTargetCountry U,
         Country C
    WHERE UserId = @UserId
    AND u.countryid = c.id)
    AND ml.name IN (SELECT
      Functionality
    FROM UserTargetFunctionality
    WHERE UserId = @UserId)
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
      li.ResultantCountry AS Country,
      li.[Url],
      ml.name AS [Functionality],
      li.SeniorityLevel,
      o.Revenue,
      O.EmployeeCount,
      I.Name AS IndustryName
    FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml
      ON (li.Id = ml.DecisionMakerId)
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
    AND (li.ResultantCountry) <> ''
    ORDER BY ls.TotalScore DESC
END
