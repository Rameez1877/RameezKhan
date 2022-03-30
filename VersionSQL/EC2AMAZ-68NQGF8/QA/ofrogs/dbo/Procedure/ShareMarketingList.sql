/****** Object:  Procedure [dbo].[ShareMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Neeraj>
-- Create date: <25 June 2020>
-- Description:	<Share Contact List withe others>
-- =============================================
CREATE PROCEDURE [dbo].[ShareMarketingList]
-- Add the parameters for the stored procedure here
@TargetPersonaId int,    --- Sharing User TargetPersonaId
@MarketingListId int, -- Sharing User MarketingListId
@UserIds int   --- Recepient UserId
AS
BEGIN

  DECLARE @Name varchar(200),
          @mlTargetPersonaId int,
          @newMarketingListId int

  SET NOCOUNT ON;

  -- Clone TargetPersona for Recepient from User

  EXEC [ShareTargetAccountInsideMarketingList] @TargetPersonaId,
                                               @UserIds,
                                               @cloneTargetPersonaId = @mlTargetPersonaId OUTPUT
  --Select @mlTargetPersonaId

  -- Make Sure you set the newly created target persona's with id @mlTargetPersonaId ISActive to 0 ,so that it will not appear on Accounts To Be Processed Screen

  --UPDATE TargetPersona
  --SET IsActive = 0
  --WHERE Id = @mlTargetPersonaId

  SELECT
    @Name = MarketingListName
  FROM marketinglists
  WHERE Id = @MarketingListId

  INSERT INTO MarketingLists (TargetPersonaId, MarketingListName, TotalAccounts, CreateDate, CreatedBy,
  TotalDecisionMakers, Locations, Functionality, Seniority)
    SELECT
      @mlTargetPersonaId,
      MarketingListName,
      TotalAccounts,
      CreateDate,
      @UserIds,
      TotalDecisionMakers,
      Locations,
      Functionality,
      Seniority
    FROM MarketingLists
    WHERE Id = @MarketingListId


  SELECT
    @newMarketingListId = Id
  FROM MarketingLists
  WHERE CreatedBy = @UserIds
  AND MarketingListName = @Name


  INSERT INTO DecisionMakersForMarketingList (MarketingListId, DecisionMakerId, LinkedInUrl, isNew,Gender,FirstName,LastName,Name,Designation,SeniorityLevel,OrganizationId,EmailId,Country,Functionality,Phone)
    SELECT
      @newMarketingListId,
      DecisionMakerId,
      LinkedInUrl,
      isNew,
	  Gender,
	  FirstName,
	  LastName,
	  Name,
	  Designation,
	  SeniorityLevel,
	  OrganizationId,
	  EmailId,
	  Country,
	  Functionality,
	  Phone
    FROM DecisionMakersForMarketingList
    WHERE MarketingListId = @MarketingListId

  ----- Saving MarketingList Configuration

  INSERT INTO MarketingListCountry (UserId, TargetPersonaId, CountryId, MarketingListId)
    SELECT DISTINCT
      @UserIds,
      @mlTargetPersonaId,
      CountryId,
      @newMarketingListId
    FROM MarketingListCountry
    WHERE MarketingListId = @MarketingListId

  INSERT INTO MarketingListFunctionality (UserId, TargetPersonaId, Functionality, MarketingListId)
    SELECT DISTINCT
      @UserIds,
      @mlTargetPersonaId,
      Functionality,
      @newMarketingListId
    FROM MarketingListFunctionality
    WHERE MarketingListId = @MarketingListId

  INSERT INTO MarketingListTechnology (UserId, TargetPersonaId, Technology, MarketingListId)
    SELECT DISTINCT
      @UserIds,
      @mlTargetPersonaId,
      Technology,
      @newMarketingListId
    FROM MarketingListTechnology
    WHERE MarketingListId = @MarketingListId

END
