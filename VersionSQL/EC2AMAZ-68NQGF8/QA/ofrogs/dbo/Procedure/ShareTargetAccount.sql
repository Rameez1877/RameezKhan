/****** Object:  Procedure [dbo].[ShareTargetAccount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <5 March 2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ShareTargetAccount]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int,    --- Sharing User TargetPersonaId
	@UserIds int   --- Recepient UserId
	
AS
BEGIN

	DECLARE
	@Name varchar(200),
	@newTargetPersonaId int,@newMarketingListId INT, @MarketingListId int

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select @Name = Name 
	from TargetPersona
	Where id = @TargetPersonaId

INSERT INTO targetpersona (Name, CreatedBy, CreateDate,EmployeeCounts,Revenues, IsActive, Type, 
AppCategories,NoOfDownloads,Locations, Industries, Technologies, Gics, Segment, Products, Solutions,SequenceNumber)
SELECT Name, @UserIds CreatedBy, getdate(), EmployeeCounts,Revenues, IsActive, Type, 
AppCategories,NoOfDownloads,Locations, Industries, Technologies, Gics, Segment, Products, Solutions,SequenceNumber
FROM  targetpersona 
where id = @TargetPersonaId

SELECT  @newTargetPersonaId = id 
FROM TargetPersona
WHERE CreatedBy = @UserIds 
AND Name = @Name

INSERT INTO TargetPersonaOrganization (TargetPersonaId, OrganizationId, SortOrder, AccountStatus)
SELECT  @newTargetPersonaId TargetPersonaId, OrganizationId, SortOrder, AccountStatus
FROM  TargetPersonaOrganization
WHERE TargetPersonaId = @TargetPersonaId

--- Saving TargetPersona Configuration

insert into ConfiguredCountry (UserId,TargetPersonaId,CountryId)
select Distinct @userIds,@newTargetPersonaId,u.CountryID 
from ConfiguredCountry u
where u.TargetPersonaId = @TargetPersonaId

insert into ConfiguredTechnology (UserId,TargetPersonaId,Technology)
select Distinct @userIds,@newTargetPersonaId,u.Technology 
from ConfiguredTechnology u
where u.TargetPersonaId = @TargetPersonaId

insert into ConfiguredFunctionality (UserId,TargetPersonaId,Functionality)
select Distinct  @userIds,@newTargetPersonaId,u.Functionality 
from ConfiguredFunctionality u
where u.TargetPersonaId = @TargetPersonaId

DECLARE @newTargetPersonaId1 INT =  @newTargetPersonaId
Return @newTargetPersonaId


-- 15-NOV-2021 - Kabir - Inserting MarketingList for the TargetAccount

 SELECT
    @Name = MarketingListName,@MarketingListId = Id
  FROM MarketingLists
  WHERE TargetPersonaId = @TargetPersonaId


  INSERT INTO MarketingLists (TargetPersonaId, MarketingListName, TotalAccounts, CreateDate, 
  CreatedBy,
  TotalDecisionMakers, Locations, Functionality, Seniority)
    SELECT
      @TargetPersonaId,
      MarketingListName,
      TotalAccounts,
      CreateDate,
      @UserIds,
      TotalDecisionMakers,
      Locations,
      Functionality,
      Seniority
    FROM MarketingLists
    WHERE TargetPersonaId = @TargetPersonaId


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
      @newTargetPersonaId1,
      CountryId,
      @newMarketingListId
    FROM MarketingListCountry
    WHERE MarketingListId = @MarketingListId

  INSERT INTO MarketingListFunctionality (UserId, TargetPersonaId, Functionality, MarketingListId)
    SELECT DISTINCT
      @UserIds,
      @newTargetPersonaId1,
      Functionality,
      @newMarketingListId
    FROM MarketingListFunctionality
    WHERE MarketingListId = @MarketingListId

  INSERT INTO MarketingListTechnology (UserId, TargetPersonaId, Technology, MarketingListId)
    SELECT DISTINCT
      @UserIds,
      @newTargetPersonaId1,
      Technology,
      @newMarketingListId
    FROM MarketingListTechnology
    WHERE MarketingListId = @MarketingListId



END
