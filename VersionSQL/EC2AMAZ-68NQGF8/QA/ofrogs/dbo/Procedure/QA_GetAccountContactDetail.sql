/****** Object:  Procedure [dbo].[QA_GetAccountContactDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Oct 10, 2021>
-- Description:	<Organization detail screen>
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetAccountContactDetail]
	-- Add the parameters for the stored procedure here
	@OrganizationId int ,
	@UserId int 
AS
/*
[dbo].[GetAccountContactDetail2] 585266, 159
*/
BEGIN
	SET NOCOUNT ON;
   select
	--distinct
	li.Id,
	li.[Name] + ', ' + li.Designation as Username,
	li.FirstName,
	li.LastName,
	li.Designation,
	li.Organization,
	li.ResultantCountry as Country,
	li.Url,
	s.EmailId,
	STRING_AGG(mc.[Name], ',') as Functionality
	--s.Phone
	from LinkedInData li with (nolock)
	inner join SurgeContactDetail s with (nolock) on (s.Url = li.url)
	inner join McDecisionmakerlist mc with (nolock) on (mc.DecisionMakerId = li.id)
	WHERE  li.organizationid = @OrganizationId AND LI.SeniorityLevel 
	IN ('C-Level','Director','Influencer','Affiliates/Consultants')

	group by 	
		li.Id,
		li.name,
		li.FirstName,
		li.LastName,
		li.Designation,
		li.Organization,
		li.ResultantCountry,
		li.Url,
		s.EmailId

END
