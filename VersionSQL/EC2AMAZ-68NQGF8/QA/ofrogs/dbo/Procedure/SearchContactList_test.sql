/****** Object:  Procedure [dbo].[SearchContactList_test]    Committed by VersionSQL https://www.versionsql.com ******/

--SELECT * FROM TARGETPERSONA WHERE CreatedBy = 159
-- EXEC [SearchContactList_TEST] 30044,13,'Automation',''
Create PROCEDURE [dbo].[SearchContactList_test]
	@TargetPersonaId int,
	@ResultantCountry varchar(8000) = '',
	@Functionality varchar(max) = '',
	@Seniority varchar(8000) 
AS
-- ==========================================================================================      
-- Author:  Asef Daqiq      
-- Create date: 17 Jun, 2021      
-- Description: Gets the Decision makers for Decision makers page   
-- ==========================================================================================   
/*
{ TargetPersonaId = 29572, ResultantCountry = "13", Functionality = "MXO", Seniority = "Director,Influencer,C-Level" }
[dbo].[SearchContactList] 30031, '13', 'MXO,Supply Chain', 'Director,Influencer,C-Level'
[dbo].[SearchContactList3] 30032, '13', 'MXO,Supply Chain', 'Director,Influencer,C-Level'

[dbo].[GetDecisionMakers_anurag] 29572 drop proc [dbo].[SearchContactList3]
*/
BEGIN

IF @Seniority = ''
BEGIN
SET @Seniority = 'C-Level,Director,Influencer,Affiliates/Consultants,Strength'
END

    DECLARE @AppRoleID int,
			  @UserId int,
			  @TargetPersonaType VARCHAR(20),
			  @TargetPersonaCreateDate DateTime,
			  @COUNT INT
			 
    SELECT
        @UserId = CreatedBy,
        @TargetPersonaType = [Type],
        @TargetPersonaCreateDate = CreateDate
    FROM TargetPersona
    WHERE ID = @TargetPersonaId

	SELECT
        @AppRoleID = A.AppRoleID
    FROM AppUser A
    WHERE A.Id = @UserId

  SELECT value as Functionality into #functionalities FROM STRING_SPLIT(@Functionality, ',')
  ;WITH CTE AS(
	    --DECLARE @Limit int = IIF(@AppRoleID = 3, 200, 100000)
    SELECT Distinct --top (@Limit)
        li.Id as LinkedInId,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] , li.Designation AS [Username],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
		s.EmailId,
        s.Phone,
        li.ResultantCountry AS Country,
		LI.ResultantCountryId,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.EmailGeneratedDate,@TargetPersonaCreateDate TargetPersonaCreateDate,
		O.WebsiteUrl
    FROM LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId) 
        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = li.OrganizationId and t.TargetPersonaId = @TargetPersonaId)
        INNER JOIN SurgeContactDetail s with (nolock)
		on (li.url = s.Url and s.WorkOrderId = 765)
		INNER JOIN Organization o with (nolock)
        on (o.Id = t.OrganizationId)
		--where 
		--ml.name IN (SELECT Functionality FROM #functionalities)
		-- and li.SeniorityLevel IN (SELECT value FROM STRING_SPLIT(@Seniority, ','))
		-- and li.ResultantCountryId IN (SELECT value FROM STRING_SPLIT(@ResultantCountry, ','))
		)
		 SELECT 
		  LinkedInId,
        Gender,
        FirstName,
        LastName,
        [Name] + ', '+ Designation AS [Username],
        [Name],
        Designation,
        Organization,
		OrganizationId,
		EmailId,
        Phone,
        Country,
        [Url],
        [Functionality],
        SeniorityLevel,
        EmailGeneratedDate,
        CONVERT(VARCHAR, TargetPersonaCreateDate, 106) as TargetPersonaCreateDate,
		WebsiteUrl,
		SUBSTRING (WebsiteUrl, CHARINDEX( '.', WebsiteUrl) + 1,
		LEN(WebsiteUrl)) AS [Domain]
		FROM CTE
		where 
		Functionality IN (SELECT Functionality FROM #functionalities)
		 and SeniorityLevel IN (SELECT value FROM STRING_SPLIT(@Seniority, ','))
		 and ResultantCountryId IN (SELECT value FROM STRING_SPLIT(@ResultantCountry, ','))	
END
