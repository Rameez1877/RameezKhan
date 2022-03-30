/****** Object:  Procedure [dbo].[PopulateMarketingListFilterSummaryTemp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[PopulateMarketingListFilterSummaryTemp] @TargetpersonaID int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @UserID Int

  SELECT @UserID =  CreatedBy from TargetPersona WHERE ID= @TargetpersonaID

  DELETE MarketingListFilter
  WHERE TargetPersonaId = @TargetpersonaID
  
  	 INSERT INTO MarketingListFilter (
	 TargetPersonaID,
	 Location,
	 Seniority,
	 NoOfRecords,
	 Industry)
    SELECT 
      @TargetpersonaID,
	  Li.ResultantCountry,
	  Li.SeniorityLevel,
      COUNT(*) as NoOfRecords,
	  i.name
     FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml WITH (NOLOCK)
      ON (li.Id = ml.DecisionMakerId)
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
	  INNER JOIN dbo.Industry I
      ON (i.id = o.industryid)
	  and o.id in (select OrganizationId from 
	  TargetPersonaOrganization where TargetPersonaId= @TargetPersonaID)
   AND  li.SeniorityLevel IN ('C-Level','Director')
	and (li.ResultantCountry)IN (Select Name from UserTargetCountry U, Country C 
	WHERE UserId = @UserId and u.countryid=c.id )
    AND ml.name  IN (Select Functionality from UserTargetFunctionality 
	WHERE UserId = @UserId )
    GROUP BY Li.ResultantCountry,
	  i.name,
	  Li.SeniorityLevel
	
END
