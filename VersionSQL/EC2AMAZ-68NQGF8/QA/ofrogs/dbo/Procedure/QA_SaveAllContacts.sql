/****** Object:  Procedure [dbo].[QA_SaveAllContacts]    Committed by VersionSQL https://www.versionsql.com ******/

-- 31-Jan-2022 -Kabir
-- EXEC [GetContactSearchResult_MK_TEMP] 159,30044,0,5000,'','',1
CREATE  PROCEDURE [dbo].[QA_SaveAllContacts]
@UserID INT,
@TargetPersonaID INT,
@LinkedInID VARCHAR(8000) = '',
@Functionality VARCHAR(500) = '',
@CountryName VARCHAR(200) = '',
@SeniorityLevel VARCHAR(200) = '',
@MarketingListName VARCHAR(200) = ''

 AS 
 BEGIN
 SET NOCOUNT ON;

		DECLARE @AppRoleID INT, @MarketingListID int
		SELECT @AppRoleID = AppRoleId FROM AppUser WHERE ID = @UserID

   -- Added by Asef on 17th March
	 INSERT INTO MarketingLists(TargetPersonaId,MarketingListName,CreateDate,CreatedBy,Locations,Functionality,Seniority)
	 values (@TargetPersonaID, @MarketingListName, GETDATE(), @UserID, @CountryName, @Functionality,
	 IIF(@SeniorityLevel = '', 'C-Level,Director,Influencer,Affiliates/Consultants', @SeniorityLevel))

	 SELECT @MarketingListID = max(Id) FROM MarketingLists WHERE CreatedBy = @UserID

	 -----
		IF @LinkedInID = ''
		BEGIN

 ;WITH CTE AS(
	
    SELECT Distinct 
        li.Id as LinkedInId,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] , li.Designation AS [Username],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
		 s.EmailId,
        li.ResultantCountry AS Country,
		LI.ResultantCountryId,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
		@TargetPersonaID TargetPersonaCreateDate,
		O.WebsiteUrl,c.UserID 
    FROM 
	LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId) 
        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = li.OrganizationId )
        INNER JOIN SurgeContactDetail s with (nolock)
		on (li.url = s.Url)
		INNER JOIN Organization o with (nolock)
        on (o.Id = t.OrganizationId)
		INNER JOIN ContactListSearchResult C  with (nolock) ON C.ID= LI.id
		WHERE C.UserID = @UserID
		and t.TargetPersonaId = @TargetPersonaID
		)
		
		

		INSERT INTO DecisionMakersForMarketingList(MarketingListId,DecisionMakerId,LinkedInUrl,Gender,FirstName,LastName,Name,Designation,OrganizationId,EmailId,Country,Functionality,SeniorityLevel)

		 SELECT distinct
		@MarketingListID,
		LinkedInId,
		  [Url],
        Gender,
        FirstName,
        LastName,
        c.[name],
        Designation,
		OrganizationId,
		EmailId,
        Country,
        C.[Functionality],
        SeniorityLevel
		FROM CTE c
		
		WHERE
		Functionality IN (SELECT DISTINCT Functionality 
		FROM ContactSearchFunctionalityResult WHERE UserID = @UserID)
		AND 
		(@Functionality = '' OR C.Functionality IN (SELECT VALUE FROM string_split(@Functionality, ',')))
		AND (@CountryName = '' OR Country IN (SELECT VALUE FROM string_split(@CountryName,',')))

		

		SELECT DISTINCT OrganizationId,Country,Functionality,Name,Designation,LinkedInUrl,EmailId into #all FROM DecisionMakersForMarketingList WHERE MarketingListId = @MarketingListID
		

		update MarketingLists set totalAccounts = (
			select count(distinct OrganizationId) 
			from DecisionMakersForMarketingList where MarketingListId = @MarketingListID),
		TotalDecisionMakers = (
			SELECT COUNT(*) FROM #all ) 
		where id = @MarketingListID
		END

		ELSE IF @LinkedInID <> ''
		BEGIN
		 ;WITH CTE AS(
	
    SELECT Distinct 
        li.Id as LinkedInId,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] , li.Designation AS [Username],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
		s.EmailId,
        li.ResultantCountry AS Country,
		LI.ResultantCountryId,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
		@TargetPersonaID TargetPersonaCreateDate,
		O.WebsiteUrl,c.UserID 
    FROM 
	LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId) 
        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = li.OrganizationId )
        INNER JOIN SurgeContactDetail s with (nolock)
		on (li.url = s.Url)
		INNER JOIN Organization o with (nolock)
        on (o.Id = t.OrganizationId)
		INNER JOIN ContactListSearchResult C  with (nolock) ON C.ID= LI.id
		WHERE C.UserID = @UserID
		and t.TargetPersonaId = @TargetPersonaID
		)
		
		

		INSERT INTO DecisionMakersForMarketingList(MarketingListId,DecisionMakerId,LinkedInUrl,Gender,FirstName,LastName,Name,Designation,OrganizationId,EmailId,Country,Functionality,SeniorityLevel)

		 SELECT distinct
		@MarketingListID,
		LinkedInId,
		  [Url],
        Gender,
        FirstName,
        LastName,
        c.[name],
        Designation,
		OrganizationId,
		EmailId,
        Country,
        C.[Functionality],
        SeniorityLevel
		FROM CTE c
		
		WHERE
		Functionality IN (SELECT DISTINCT Functionality 
		FROM ContactSearchFunctionalityResult WHERE UserID = @UserID)
		AND 
		(@Functionality = '' OR C.Functionality IN (SELECT VALUE FROM string_split(@Functionality, ',')))
		AND (@CountryName = '' OR Country IN (SELECT VALUE FROM string_split(@CountryName,',')))
		AND LinkedInId IN (SELECT VALUE FROM string_split(@LinkedInID,','))
			
		

		SELECT DISTINCT OrganizationId,Country,Functionality,Name,Designation,LinkedInUrl,EmailId into #S FROM DecisionMakersForMarketingList WHERE MarketingListId = @MarketingListID
		

		update MarketingLists set totalAccounts = (
			select count(distinct OrganizationId) 
			from DecisionMakersForMarketingList where MarketingListId = @MarketingListID),
		TotalDecisionMakers = (
			SELECT COUNT(*) FROM #S ) 
		where id = @MarketingListID
		END
		
END
