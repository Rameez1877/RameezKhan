/****** Object:  Procedure [dbo].[GetDecisionMakersForSurge_anurag2]    Committed by VersionSQL https://www.versionsql.com ******/

--exec [GetDecisionMakersForSurge] 2698,'Project Management','India'
-- =============================================
-- Author:  	<Author,,Name>
-- Create date: 30/Oct/2019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForSurge_anurag2]
-- Add the parameters for the stored procedure here
@OrganizationId int,
@SubMarketingList varchar(200),
@Location varchar(200),
@UserId int
AS
/*
[dbo].[GetDecisionMakersForSurge] 85459, 'Sales', 125, 300
[dbo].[GetDecisionMakersForSurge_anurag2] 85459, 'Sales', 125, 300
*/
BEGIN

  SET NOCOUNT ON;
  SELECT
	li.id,
	li.[name],
	li.firstname,
	li.lastname,
	li.OrganizationName as organization,
    li.designation,
	li.SeniorityLevel,
	s.emailId,
	s.phone,
	s.LinkedinId,
	li.gender,
	df.Functionality,
    li.CountryName AS country,
    li.url,
	li.IsNewHire,
	li.IsChampion,
	li.FirstSuggestedDomain as Domain,
	lic.PreviousOrganization,
	lic.YearOfJoining
 FROM cache.DecisionMakers li with (nolock)
  INNER JOIN cache.DecisionMakerFunctionality df  with (nolock)
    ON (li.id = df.DecisionmakerId)
	LEFT Outer Join LinkedInDataChampion lic
	on (li.id = lic.LinkedInDataID)
	--added by Asef
  left outer join SurgeContactDetail s
  on (li.id = s.linkedinId)
  and s.UserId = @UserId
  and s.Source = 'Surge'
  --added by Asef
  INNER JOIN dbo.Tag T  with (nolock)
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)
	INNER JOIN Organization O
	on (o.id = t.OrganizationID)
   WHERE T.OrganizationId = @OrganizationId
  AND df.Functionality = @SubMarketingList
  --and li.senioritylevel in ('C-Level','Director','Influencer')
  and li.CountryName = @Location 
  Order by li.IsNewHire desc, li.IsChampion desc
 
END
