/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList_anurag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList_anurag]
    @MarketingListId int,
    @UserId int = 0
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================   
/*
exec GetDecisionMakersForMarketingList 1589, 315
exec GetDecisionMakersForMarketingList_anurag 8680, 5951

exec GetDecisionMakersForMarketingList 1590, 316
exec GetDecisionMakersForMarketingList_anurag 4726, 263
*/
BEGIN
    DECLARE @AppRoleID int --@Limit int
    SELECT
        @AppRoleID = A.AppRoleID
    FROM AppUser A with (nolock)
    WHERE A.Id = @UserId

	DECLARE @TargetPersonaId int
	DECLARE @TargetPersonaType varchar(10)
	Select @TargetPersonaId = TargetPersonaId from MarketingLists where id = @marketingListId
	Select @TargetPersonaType = [Type] from TargetPersona where id = @TargetPersonaId

	-- Set @Limit = IIF(@AppRoleID = 3, 200, 50000)

		SELECT	DISTINCT 
				 d.DecisionMakerId as Id,
				 d.Gender, 
				 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
				 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
				 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
				 d.[Name] + ', ' + d.Designation as Username,
				 d.Name, d.Designation,o.Name as Organization, o.Id as OrganizationId, o.Revenue,o.EmployeeCount,
				 d.Functionality,
				 o.WebsiteUrl,SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			     LEN(O.WebsiteUrl)) AS [Domain],i.Name as IndustryName,
				 '' as Phone,
				 IIF(d.Country = 'United States Of America',c.TimeZone,NULL) as TimeZone,
				--d.EmailGeneratedDate,
				CONVERT(VARCHAR, m.CreateDate, 106) as MarketingListCreateDate, d.Country, 
				d.LinkedInUrl as Url,m.MarketingListName, m.Id as MarketinglistId,d.Senioritylevel,
				IIF(h.Url IS NOT NULL,'Exported','Not Exported') as ExportStatus
				into #tempProfile
		FROM	DecisionMakersForMarketingList d
				INNER JOIN Organization o ON (d.OrganizationId = o.Id)
				INNER JOIN Industry i ON (o.IndustryId = i.Id)
				INNER JOIN MarketingLists m ON (d.MarketingListId = m.Id)
				LEFT JOIN HubSpotSharedProfiles h ON (d.LinkedInUrl = h.Url AND h.UserId = @UserId)
				LEFT OUTER Join CountryTimeZone c
				ON (CAST(TRIM(substring(Replace(Replace(Replace(Replace(Replace(d.Phone,' ',''),'-',''),'+',''),'(',''),')',''),2,3)) as varchar(4))
				= CAST(c.AreaCode as varchar(4)))
		WHERE	d.MarketingListId = @MarketingListId
		and d.EmailId <> ''

			SELECT DISTINCT -- top (@Limit)
					Id,
					Gender,
					 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
			  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
					Username,
					Name, Designation,Organization, OrganizationId,
					Revenue,EmployeeCount,
					STRING_AGG(Functionality,',') as Functionality,
					WebsiteUrl,Domain, 
					IndustryName,
					Phone,
					TimeZone,
					--CONVERT(VARCHAR, EmailGeneratedDate, 106) as EmailGeneratedDate,
					MarketingListCreateDate, Country, 
					Url,MarketingListName,MarketinglistId,Senioritylevel,
					ExportStatus,
				   @TargetPersonaId as TargetPersonaId,
				   @TargetPersonaType as TargetPersonaType

			FROM	#tempProfile
			GROUP BY Id, Gender, FirstName,LastName,Username,
					Name, Designation,Organization, OrganizationId, Revenue,EmployeeCount,WebsiteUrl,Domain, IndustryName,EmailId,Phone,
					TimeZone, --CONVERT(VARCHAR, EmailGeneratedDate, 106),
					MarketingListCreateDate, Country,Url,MarketingListName,MarketinglistId,Senioritylevel,
					ExportStatus
					order by EmailId
	END
