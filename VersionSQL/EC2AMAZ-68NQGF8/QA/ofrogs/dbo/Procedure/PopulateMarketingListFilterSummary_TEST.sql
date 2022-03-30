/****** Object:  Procedure [dbo].[PopulateMarketingListFilterSummary_TEST]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateMarketingListFilterSummary_TEST] @TargetpersonaID int
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

select O.Id, O.IndustryId, O.Revenue, O.EmployeeCount into #tempOrganization 
from Organization O WITH (NOLOCK) INNER JOIN TargetPersonaOrganization TPO  WITH (NOLOCK)
ON TPO.OrganizationId = O.Id
AND TPO.TargetPersonaId = @TargetPersonaID

--Where Id in (select OrganizationId from TargetPersonaOrganization where TargetPersonaId= @TargetPersonaID)

  select Url,UNIQUEID into #SurgeContactDetail 
  from SurgeContactDetail  WITH (NOLOCK)
  where UserId = @UserId AND (EmailId IS NOT NULL AND EmailId <> '' AND
  EmailGeneratedDate > DATEADD(DAY,-15,GETDATE()))

  Select LI.Id,LI.OrganizationId,LI.Url,LI.ResultantCountry, LI.Senioritylevel,LI.ResultantCountryId,LI.UNIQUEID into #tempLinkedInData 
  from LinkedInData LI WITH (NOLOCK)
  INNER JOIN #SurgeContactDetail SG WITH (NOLOCK)
  ON LI.UNIQUEID = SG.UNIQUEID
  --where url in (select url from #SurgeContactDetail)	   
  
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

    INNER JOIN #tempOrganization o WITH (NOLOCK)
      ON (o.id = li.organizationid)

	  INNER JOIN dbo.Industry I WITH (NOLOCK)
      ON (i.id = o.industryid)

	  INNER JOIN UserTargetSeniority UTS WITH (NOLOCK)
	  ON UTS.Seniority = LI.SeniorityLevel 	AND UTS.USERID = @UserID

	  INNER JOIN ConfiguredCountry CU WITH (NOLOCK)
	  ON CU.CountryId = li.ResultantCountryID  AND CU.TargetPersonaId = @TargetPersonaId

	  INNER JOIN ConfiguredFunctionality CF WITH (NOLOCK)
	  ON CF.Functionality = ML.Name AND CF.TargetPersonaId = @TargetpersonaID
	  

	-- AND li.SeniorityLevel in (select Seniority from UserTargetSeniority where userid = @UserID)
	--and 
	--(li.ResultantCountry)IN (Select Name from ConfiguredCountry U, Country C 
	--WHERE u.TargetPersonaId = @TargetPersonaId and u.countryid=c.id )
 --   AND
	--ml.name  IN (Select Functionality from ConfiguredFunctionality 
	--WHERE TargetPersonaId = @TargetPersonaId ) 
    
	GROUP BY 
	  Li.ResultantCountry,
	  i.name,
	  O.Revenue,
	  O.EmployeeCount,
	  li.SeniorityLevel,
	  Ml.Name
END
