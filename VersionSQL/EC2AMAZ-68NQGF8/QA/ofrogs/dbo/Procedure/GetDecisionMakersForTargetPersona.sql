/****** Object:  Procedure [dbo].[GetDecisionMakersForTargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <2019/07/22>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForTargetPersona]
	-- Add the parameters for the stored procedure here
	@OrganizationId int ,
	@UserId int 
AS
BEGIN
	SET NOCOUNT ON;
   select
  --  top 20
	li.FirstName,
	li.LastName,
	li.designation,
	li.ResultantCountry as country,
	li.url
	from LinkedInData li with (nolock)
	--inner join dbo.Tag T on (T.Id = li.TagId)
	--where t.organizationid = @OrganizationId
	inner join McDecisionmakerlist mc with (nolock) on (mc.DecisionMakerId = li.id)
	where li.organizationid = @OrganizationId
	AND  li.SeniorityLevel IN (select seniority from UserTargetSeniority 
	where userid=@UserId)
	and (li.ResultantCountry)IN (Select Name from UserTargetCountry U, Country C 
	WHERE UserId = @UserId and u.countryid=c.id )
	AND mc.name  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId)
	--AND  exists 
	--(
	--select * from McDecisionmakerlist mc with (nolock)
	--where mc.DecisionMakerId = li.id
	--AND mc.name  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId)
	--)
	
END
