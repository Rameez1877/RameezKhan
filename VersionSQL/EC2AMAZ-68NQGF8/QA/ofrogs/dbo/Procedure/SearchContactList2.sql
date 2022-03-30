/****** Object:  Procedure [dbo].[SearchContactList2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SearchContactList2]
    @TargetPersonaId int,
	@ResultantCountry varchar(8000) = '',
	@Functionality varchar(8000) = '',
	@Seniority varchar(8000) = ''
AS
-- ==========================================================================================      
-- Author:  Asef Daqiq      
-- Create date: 17 Jun, 2021      
-- Description: Gets the Decision makers for Decision makers page   
-- ==========================================================================================   
/*
{ TargetPersonaId = 29572, ResultantCountry = "13", Functionality = "MXO", Seniority = "Director,Influencer,C-Level" }
[dbo].[SearchContactList2] 29572, '13', 'MXO,Supply Chain,CXO,Procurement,Logistics', 'Director,Influencer,C-Level'
[dbo].[GetDecisionMakers_anurag] 29572
*/
BEGIN
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

    DECLARE @Limit int = IIF(@AppRoleID = 3, 500, 100000)

    SELECT Distinct top (@Limit)
        li.Id,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] + ', ' + li.Designation AS [Username],
        li.[Name],
        li.Designation,
        li.organization AS Organization,
		li.OrganizationId,
        case when @AppRoleID = 3 then '****' else s.EmailId end EmailId,
        case when @AppRoleID = 3 then null else s.Phone end as Phone,
        li.ResultantCountry AS Country,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.EmailGeneratedDate,
        CONVERT(VARCHAR, @TargetPersonaCreateDate, 106) as TargetPersonaCreateDate
    FROM LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId)
        INNER JOIN TargetPersonaOrganization o with (nolock)
        ON (o.OrganizationId = li.OrganizationId and o.TargetPersonaId = @TargetPersonaId)
        INNER JOIN SurgeContactDetail s with (nolock)
        on (li.url = s.Url and s.UserId = @UserId)
    WHERE 
        ml.name  IN (SELECT value FROM STRING_SPLIT(@Functionality, ','))
		AND (li.SeniorityLevel IN ('C-Level','Director','Influencer') OR li.SeniorityLevel IN (SELECT value FROM STRING_SPLIT(@Seniority, ',')))
        and li.ResultantCountryId IN (SELECT value FROM STRING_SPLIT(@ResultantCountry, ','))
    order by EmailGeneratedDate desc
END
