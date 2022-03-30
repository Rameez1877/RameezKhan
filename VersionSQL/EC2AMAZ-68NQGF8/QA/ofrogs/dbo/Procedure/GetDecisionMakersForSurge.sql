/****** Object:  Procedure [dbo].[GetDecisionMakersForSurge]    Committed by VersionSQL https://www.versionsql.com ******/

--exec [GetDecisionMakersForSurge] 2698,'Project Management','India'
-- =============================================
-- Author:  	<Asef Daqiq>
-- Create date: 30/Oct/2019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForSurge]
-- Add the parameters for the stored procedure here
@OrganizationId int,
@SubMarketingList varchar(200),
@Location varchar(200),
@UserId int
AS
BEGIN

  SET NOCOUNT ON;
  SELECT
	li.Id,
	li.Name,
	li.FirstName,
	li.LastName,
	--li.organization,
	o.name as Organization,
    li.Designation,
	li.SeniorityLevel,
	s.EmailId,
	s.Phone,
	s.LinkedinId,
	li.Gender,
	Mc.name as Functionality,
    li.ResultantCountry AS Country,
    li.Url,
	li.IsNewHire,
	li.IsChampion,
	li.firstsuggested_domainname as Domain,
	lic.PreviousOrganization,
	lic.YearOfJoining
 FROM LinkedInData  li with (nolock)
  INNER JOIN McDecisionMakerList Mc  with (nolock)
    ON (li.id = Mc.DecisionmakerId)
	LEFT Outer Join LinkedInDataChampion lic
	on (li.id = lic.LinkedInDataID)
	--added by Asef
  left outer join SurgeContactDetail s
  on (li.id = s.linkedinId)
  and s.UserId = @UserId
  and s.Source = 'Surge'
  --added by Asef
	INNER JOIN Organization O
	on (o.id = li.OrganizationID)
   WHERE o.Id = @OrganizationId
  AND mc.Name = @SubMarketingList
  --and li.senioritylevel in ('C-Level','Director','Influencer')
  and li.ResultantCountry = @Location 
  Order by li.IsNewHire desc, li.IsChampion desc
 
END
