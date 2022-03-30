/****** Object:  Procedure [dbo].[GetDecisionMakers_anurag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakers_anurag]
    @TargetPersonaId int
AS
-- ==========================================================================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page   
-- ==========================================================================================   
/*
[GetDecisionMakers] 14647 
[GetDecisionMakers_anurag] 14647 
exec GetDecisionMakers_anurag 20990
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

	SELECT @COUNT =  COUNT(*)
	FROM SurgeContactDetail WHERE USERID =  @USERID
	and (EmailId IS NOT NULL AND EmailId <> '')
	and EmailGeneratedDate > DATEADD(DAY,-15,GETDATE())

	IF @COUNT <> 0 BEGIN
    select Id, [Url], isNew, EmailId, 
		 --  CASE 
			--WHEN 
			--	(Phone IS NOT NULL AND Phone <> '')
			--THEN
			--	'+' + substring(Replace(Replace(Replace(Replace(Replace(Phone,' ',''),'-',''),'+',''),'(',''),')',''),1,3) + ' ' 
			--	+ substring(Replace(Replace(Replace(Replace(Replace(Phone,' ',''),'-',''),'+',''),'(',''),')',''),4,4) + ' ' +
			--	substring(Replace(Replace(Replace(Replace(Replace(Phone,' ',''),'-',''),'+',''),'(',''),')',''),8,50) 
			--ELSE 
			--	Phone 
		 -- END AS Phone,
		 Phone,
		  EmailGeneratedDate into #SurgeContactDetail 
	from SurgeContactDetail WHERE UserId = @UserId
	and (EmailId IS NOT NULL AND EmailId <> '')
	and EmailGeneratedDate > DATEADD(DAY,-15,GETDATE())

    select *
    into #LinkedInData
    from
        dbo.LinkedInData li WITH (NOLOCK)
    WHERE 
        li.[Url] <> ''
        and OrganizationId in (select OrganizationId
        from TargetPersonaOrganization
        where TargetPersonaId = @TargetPersonaId)
        AND li.SeniorityLevel IN (select seniority
        from UserTargetSeniority with (nolock)
        where userid=@UserId)
        and (li.ResultantCountryId) IN (Select U.CountryId -- Changed by Neeraj (CountryName to CountryId)21/12/20
        from ConfiguredCountry U with (nolock)
        WHERE u.TargetPersonaId = @TargetPersonaId)
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
        o.[name] AS Organization,
		o.Id as OrganizationId,
        case when @AppRoleID = 3 then '****' else s.EmailId end EmailId,
        case when @AppRoleID = 3 then null else s.Phone end as Phone,
        s.Url as ContactsUrl,
        li.ResultantCountry AS Country,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.isNew,
        s.EmailGeneratedDate,
        CONVERT(VARCHAR, @TargetPersonaCreateDate, 106) as TargetPersonaCreateDate,
        s.id as SurgeContactId
    FROM #LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId)
        INNER JOIN dbo.Organization o with (nolock)
		--for the issue of organzationid in the targetpersonaorganization
		--not matching the organizationid in linkedindata we must modify the below line
		-- ON (o.id = s.OrganizationId)
        ON (o.id = li.OrganizationId)
        INNER JOIN #SurgeContactDetail s with (nolock)
        on (li.url = s.Url)
    WHERE 
       -- ml.mode = 'Keyword Based List'
        ml.name  IN (Select Functionality
        from ConfiguredFunctionality with (nolock)
        WHERE TargetPersonaId = @TargetPersonaId )
    order by EmailGeneratedDate desc
	END
	ELSE print 'There are no DecisionMakers'
END
