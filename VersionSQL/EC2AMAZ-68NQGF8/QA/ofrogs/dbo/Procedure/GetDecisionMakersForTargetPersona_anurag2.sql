/****** Object:  Procedure [dbo].[GetDecisionMakersForTargetPersona_anurag2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <2019/07/22>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForTargetPersona_anurag2]
	-- Add the parameters for the stored procedure here
	@OrganizationId int,
	@UserId int 
AS
BEGIN
	SET NOCOUNT ON;
	select
		--  top 20
		li.FirstName,
		li.LastName,
		li.designation,
		li.CountryName as country,
		li.url
	from 
		cache.DecisionMakers li with (nolock)
	where 
		li.organizationid = @OrganizationId
		AND li.SeniorityLevel IN (select seniority from UserTargetSeniority where userid=@UserId)
		and (li.CountryId) IN (Select CountryId from UserTargetCountry U WHERE UserId = @UserId)
		AND exists 
		(
			select * from cache.DecisionMakerFunctionality mc with (nolock)
			where mc.DecisionMakerId = li.id
			AND mc.Functionality  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId)
		)
	
END
