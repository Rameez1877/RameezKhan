/****** Object:  Procedure [dbo].[ShareDecisionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <13th Jan 2021>
-- Description:	<Share decision makers with your team member>
-- =============================================
CREATE PROCEDURE ShareDecisionMakers
@MarketingListId int,
@RecepientUserId int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @UserId int

	SELECT @UserId = CreatedBy FROM MarketingLists where Id = @MarketingListId

	SELECT DISTINCT s.*
		   into #profiles
	FROM DecisionMakersForMarketingList d
		 Inner Join SurgeContactDetail s ON (d.LinkedinUrl = s.Url)
	WHERE
		d.MarketingListId = @MarketingListId
		AND s.UserId = @UserId
		
	
	exec('disable trigger SurgeContactDetail_Prevent_delete on SurgeContactDetail')
    delete from SurgeContactDetail where UserId = @RecepientUserId and [Url] in (select Url from #profiles)
    exec('enable trigger SurgeContactDetail_Prevent_delete on SurgeContactDetail')

	
	
	INSERT INTO SurgeContactDetail([UserId], [LinkedinId], [Name], [Designation], [EmailId], [Phone], [domain], [ConfidenceScore], [GeneratedBy], [EmailGeneratedDate], [Url], [Functionality], [Organization], [Location], [Gender], [RocketreachOrganization], [RocketreachDesignation], [RocketreachLocation], [Source], [SeniorityLevel], [PersonalEmail], [isNew])
	SELECT	DISTINCT
			@RecepientUserId as [UserId],
			[LinkedinId], 
			[Name], 
			[Designation],
			[EmailId], 
			[Phone], 
			[domain], 
			[ConfidenceScore], 
			[GeneratedBy], 
			[EmailGeneratedDate], 
			[Url], 
			[Functionality], 
			[Organization], 
			[Location], 
			[Gender], 
			[RocketreachOrganization], 
			[RocketreachDesignation], 
			[RocketreachLocation], 
			[Source], 
			[SeniorityLevel], 
			[PersonalEmail], 
			[isNew]
	FROM 
		#profiles

	DROP TABLE #profiles
END
