/****** Object:  Procedure [dbo].[ShareAccountsAndContactDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <02nd Feb 2021>
-- Description:	<Share Account and Contact List with team members>
-- =============================================
CREATE PROCEDURE [dbo].[ShareAccountsAndContactDetails]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int,    --- Sharing User TargetPersonaId
	@UserIds int,   --- Recepient UserId
	@MarketingListId int -- Sharing User MarketingListId
AS
BEGIN

	DECLARE
	@Name varchar(200),
	@mlTargetPersonaId int,
	@newMarketingListId int

	SET NOCOUNT ON;

	-- Clone TargetPersona for Recepient from User
	 
	Exec [ShareTargetAccountInsideMarketingList] @TargetPersonaId,@UserIds, @cloneTargetPersonaId = @mlTargetPersonaId OUTPUT 
	--Select @mlTargetPersonaId

	Select @Name = MarketingListName from marketinglists
	where Id = @MarketingListId

	Insert Into MarketingLists 
		(
			TargetPersonaId,MarketingListName,TotalAccounts,CreateDate,CreatedBy,
			TotalDecisionMakers,Locations,Functionality,Seniority
		)
	SELECT  @mlTargetPersonaId,MarketingListName,TotalAccounts,CreateDate,@UserIds,
			TotalDecisionMakers,Locations,Functionality,Seniority
	FROM	MarketingLists
	where	Id = @MarketingListId


	SELECT	@newMarketingListId = Id 
	from MarketingLists
	where CreatedBy = @UserIds and MarketingListName = @Name


	Insert Into DecisionMakersForMarketingList (MarketingListId,DecisionMakerId,LinkedInUrl,isNew)
	SELECT @newMarketingListId,DecisionMakerId,LinkedInUrl,isNew
	FROM DecisionMakersForMarketingList
	where MarketingListId = @MarketingListId

----- Saving MarketingList Configuration

	Insert Into MarketingListCountry (UserId,TargetPersonaId,CountryId,MarketingListId)
	SELECT DISTINCT @UserIds,@mlTargetPersonaId,CountryId,@newMarketingListId
	FROM MarketingListCountry 
	WHERE MarketingListId = @MarketingListId

	Insert Into MarketingListFunctionality (UserId,TargetPersonaId,Functionality,MarketingListId)
	SELECT DISTINCT @UserIds,@mlTargetPersonaId,Functionality,@newMarketingListId
	FROM MarketingListFunctionality  
	WHERE MarketingListId = @MarketingListId

	Insert Into MarketingListTechnology (UserId,TargetPersonaId,Technology,MarketingListId)
	SELECT DISTINCT @UserIds,@mlTargetPersonaId,Technology,@newMarketingListId
	FROM MarketingListTechnology 
	WHERE MarketingListId = @MarketingListId

	-- Share decision makers with your team member in surge contact detail

	Exec ShareDecisionMakers @MarketingListId,@UserIds

END
