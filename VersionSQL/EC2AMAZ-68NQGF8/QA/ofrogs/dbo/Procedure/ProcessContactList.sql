/****** Object:  Procedure [dbo].[ProcessContactList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <02nd Feb 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[ProcessContactList]
@UserId int = 0,
@Task int = 0,
@KeywordLinkedInId varchar(MAX) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MarketingListId int
	DECLARE @DeleteRows int = 0
	--DECLARE @InsertRows int = 0

	-- To check the latest MarketingListid for the given user
	IF @Task = 1
		BEGIN
			SELECT	TOP 1 
					Id as MarketingListId,
					TargetPersonaId,
					MarketingListName,
					CreatedBy as UserId,
					CreateDate as CreatedDate,
					TotalDecisionMakers
			FROM	MarketingLists
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc
		END
	
	-- To check contact details for the given userid
	IF @Task = 2
		BEGIN
			SELECT	TOP 1 
					@MarketingListId = Id
			FROM	MarketingLists
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc

			SELECT	DISTINCT
					l.Id as LinkedInId,
					l.Name,
					l.Organization,
					l.Designation,
					l.Url,
					l.SeniorityLevel,
					m.Name as Functionality,
					l.OrganizationId
			FROM	DecisionMakersForMarketingList d
					INNER JOIN LinkedInData l ON (d.LinkedInUrl = l.Url)
					INNER JOIN McDecisionMakerList m ON (l.Id = m.DecisionMakerid)
			WHERE	d.MarketingListId = @MarketingListId

		END

	-- Delete not required profiles from the latest contact List
	IF @Task = 3
		BEGIN
			SELECT	TOP 1 
					@MarketingListId = Id
			FROM	MarketingLists
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc

			DELETE	FROM 
					DecisionMakersForMarketingList
			WHERE	MarketingListId = @MarketingListId
					AND LinkedInUrl NOT IN
					(SELECT Url FROM SurgeContactDetail WHERE UserId = @UserId)
			SELECT @DeleteRows = @@RowCount


		END
	
	-- Insert required Profile in the contact list
	--IF @Task = 4
	--	BEGIN
	--		SELECT	TOP 1 
	--				@MarketingListId = Id
	--		FROM	MarketingLists
	--		WHERE	CreatedBy = @UserId
	--		ORDER BY Id Desc

	--		INSERT INTO	DecisionMakersForMarketingList(MarketingListId,DecisionmakerId,LinkedInUrl)
	--		SELECT	DISTINCT
	--				@MarketingListId,
	--				Id as DecisionmakerId,
	--				Url as LinkedInUrl
	--		FROM	LinkedInData
	--		WHERE	Id IN STRING_SPLIT(@KeywordLinkedInId,',')
	--		SELECT @InsertRows = @@RowCount
	--	END
		
		IF @DeleteRows <> 0
			BEGIN
				PRINT 'Total Number of records deleted = ' + TRIM(STR(@DeleteRows))
			END
		--IF @InsertRows <> 0
		--	BEGIN
		--		PRINT 'Total Number of records inserted = ' + TRIM(STR(@InsertRows))
		--	END
END
