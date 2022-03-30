/****** Object:  Procedure [dbo].[SearchContactList3]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SearchContactList3]
    @TargetPersonaId int,
	@ResultantCountry varchar(8000) = '',
	@Functionality varchar(max) = '',
	@Seniority varchar(8000) = ''
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

SET @Seniority = @Seniority + 'C-Level,Director,Influencer'

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

	    DECLARE @Limit int = IIF(@AppRoleID = 3, 200, 100000)
    SELECT Distinct top (@Limit)
        li.Id as LinkedInId,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] + ', ' + li.Designation AS [Username],
        li.[Name],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
        -- case when @AppRoleID = 3 then '****' else s.EmailId end EmailId,
        -- case when @AppRoleID = 3 then null else s.Phone end as Phone,
		s.EmailId,
        s.Phone,
        li.ResultantCountry AS Country,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.EmailGeneratedDate,
        CONVERT(VARCHAR, @TargetPersonaCreateDate, 106) as TargetPersonaCreateDate,
		O.WebsiteUrl,
		SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
		LEN(O.WebsiteUrl)) AS [Domain]
    FROM LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId) 
		inner join #functionalities f on (ml.Name = f.Functionality)
		--and ml.name  IN (SELECT trim(Functionality) FROM #functionalities)
	

        INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = li.OrganizationId and t.TargetPersonaId = @TargetPersonaId)
		
        INNER JOIN SurgeContactDetail s with (nolock)
        --on (li.uniqueid = s.uniqueid and s.UserId = @UserId and s.EmailGeneratedDate > DATEADD(DAY,-15,GETDATE()))
		on (li.uniqueid = s.uniqueid)
		INNER JOIN Organization o with (nolock)
        on (o.Id = t.OrganizationId and t.TargetPersonaId = @TargetPersonaId)
		where 
		--ml.name IN (SELECT trim(Functionality) FROM #functionalities)
		 li.SeniorityLevel IN ('C-Level','Director','Influencer')
		--OR li.SeniorityLevel IN (SELECT value FROM STRING_SPLIT(@Seniority, ',')))
		 and li.ResultantCountryId IN (SELECT value FROM STRING_SPLIT(@ResultantCountry, ','))
	     --and t.TargetPersonaId = @TargetPersonaId

       
		
    --order by EmailGeneratedDate desc
END
