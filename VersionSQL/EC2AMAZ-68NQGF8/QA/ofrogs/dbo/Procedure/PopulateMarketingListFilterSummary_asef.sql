/****** Object:  Procedure [dbo].[PopulateMarketingListFilterSummary_asef]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateMarketingListFilterSummary_asef] @TargetpersonaID int
AS
BEGIN 
  SET NOCOUNT ON;
  DECLARE @UserID Int

  SELECT @UserID =  CreatedBy from TargetPersona WHERE ID= @TargetpersonaID

  DELETE MarketingListFilterCopy
  WHERE TargetPersonaId = @TargetpersonaID
  
--  	 INSERT INTO MarketingListFilterCopy (
--	 TargetPersonaID,
--	 Location,
--	 Revenue,
--	 EmployeeCount,
--	 NoOfRecords,
--	 Industry,
--	 Seniority,
--	 Functionality)
--    SELECT 
--      @TargetpersonaID,
--	  Li.ResultantCountry,
--	  O.Revenue,
--	  O.EmployeeCount,
--      COUNT(*) as NoOfRecords,
--	  i.name,
--	  li.SeniorityLevel,
--	  ml.Name
--     FROM dbo.LinkedInData li WITH (NOLOCK)
--    INNER JOIN dbo.McDecisionMakerList ml WITH (NOLOCK)
--      ON (li.Id = ml.DecisionMakerId)
--    INNER JOIN dbo.SurgeContactDetail s
--      ON (s.Url = li.Url and s.UserId = @UserID)
--    INNER JOIN dbo.Organization o
--      ON (o.id = li.organizationid)
--	  INNER JOIN dbo.Industry I
--      ON (i.id = o.industryid)
--	  and o.id in (select OrganizationId from 
--	  TargetPersonaOrganization where TargetPersonaId= @TargetPersonaID)
--	 AND li.SeniorityLevel in (select Seniority from UserTargetSeniority where userid = @UserID)
--	and (li.ResultantCountry)IN (Select Name from ConfiguredCountry U, Country C 
--	WHERE u.TargetPersonaId = @TargetPersonaId and u.countryid=c.id )
--    AND ml.name  IN (Select Functionality from ConfiguredFunctionality 
--	WHERE TargetPersonaId = @TargetPersonaId )
--	AND (s.EmailId IS NOT NULL AND s.EmailId <> '') 
--    GROUP BY 
--	  Li.ResultantCountry,
--	  i.name,
--	  O.Revenue,
--	  O.EmployeeCount,
--	  li.SeniorityLevel,
--	  Ml.Name

--END

	select Id, IndustryId, Revenue, EmployeeCount into #tempOrganization 
	from Organization o 
	inner join TargetPersonaOrganization tpo on (o.Id = tpo.OrganizationId)
	and tpo.TargetPersonaId = @TargetpersonaID
	
  select UniqueId into #SurgeContactDetail from SurgeContactDetail where UserId = @UserId AND EmailGeneratedDate > DATEADD(DAY,-15,GETDATE())
  Select Id,OrganizationId,Url,ResultantCountryId, ResultantCountry, Senioritylevel into #tempLinkedInData from LinkedInData l with (nolock)
  inner join #SurgeContactDetail s on (s.uniqueId = l.uniqueid)
    
  
  INSERT INTO MarketingListFilterCopy (
	 TargetPersonaID,
	 Location,
	 Revenue,
	 EmployeeCount,
	 NoOfRecords,
	 Industry,
	 Seniority,
	 Functionality)
    SELECT 
      @TargetpersonaID,
	  Li.ResultantCountry,
	  O.Revenue,
	  O.EmployeeCount,
      COUNT(*) as NoOfRecords,
	  i.name,
	  li.SeniorityLevel,
	  ml.Name
     FROM #tempLinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml WITH (NOLOCK)
      ON (li.Id = ml.DecisionMakerId)
    INNER JOIN #tempOrganization o
      ON (o.id = li.organizationid)
	  INNER JOIN dbo.Industry I
      ON (i.id = o.industryid)
	 AND li.SeniorityLevel in (select Seniority from UserTargetSeniority where userid = @UserID)
	and (li.ResultantCountryId)IN (Select CountryId from ConfiguredCountry U
	WHERE u.TargetPersonaId = @TargetPersonaId)
    AND ml.[name]  IN (Select Functionality from ConfiguredFunctionality 
	WHERE TargetPersonaId = @TargetPersonaId ) 
    GROUP BY 
	  Li.ResultantCountry,
	  i.[name],
	  O.Revenue,
	  O.EmployeeCount,
	  li.SeniorityLevel,
	  Ml.[Name]
END
