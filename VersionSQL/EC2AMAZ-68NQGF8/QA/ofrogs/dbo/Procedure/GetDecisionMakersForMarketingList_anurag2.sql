/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList_anurag2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList_anurag2]
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
exec GetDecisionMakersForMarketingList_anurag 1589, 315

exec GetDecisionMakersForMarketingList 1590, 316
exec GetDecisionMakersForMarketingList_anurag 4726, 263
*/
BEGIN
    DECLARE @AppRoleID int
    SELECT
        @AppRoleID = A.AppRoleID
    FROM AppUser A with (nolock)
    WHERE A.Id = @UserId

	DECLARE @TargetPersonaId int
	DECLARE @TargetPersonaType varchar(10)
	Select @TargetPersonaId = TargetPersonaId from MarketingLists where id = @marketingListId
	Select @TargetPersonaType = [Type] from TargetPersona where id = @TargetPersonaId

		SELECT	DISTINCT 
				d.DecisionMakerId as Id,
				d.Gender, 
				 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
			  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
				 d.[Name] + ', ' + d.Designation as Username,
				d.Name, d.Designation,o.Name as Organization, o.Revenue,o.EmployeeCount,
				d.Functionality,o.WebsiteUrl,SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],i.Name as IndustryName,d.Phone,
				IIF(d.Country = 'United States Of America',c.TimeZone,NULL) as TimeZone,
				NULL as LinkedinId, d.LinkedInUrl as SurgeContactUrl,
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

		IF @AppRoleID <> 3
		BEGIN
		print 'else part2'
			SELECT	DISTINCT 
					Id,
					Gender,
					 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
			  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
					Username,
					Name, Designation,Organization, Revenue,EmployeeCount,
					STRING_AGG(Functionality,',') as Functionality,WebsiteUrl,Domain, 
					IndustryName,Phone,
					TimeZone,LinkedinId,SurgeContactUrl,
					--CONVERT(VARCHAR, EmailGeneratedDate, 106) as EmailGeneratedDate,
					MarketingListCreateDate, Country, 
					Url,MarketingListName,MarketinglistId,Senioritylevel,
					ExportStatus,
				   @TargetPersonaId as TargetPersonaId,
				   @TargetPersonaType as TargetPersonaType

			FROM	#tempProfile
			GROUP BY Id,
			Gender, FirstName,LastName,Username,
					Name, Designation,Organization, Revenue,EmployeeCount,WebsiteUrl,Domain, IndustryName,EmailId,Phone,
					TimeZone,LinkedinId,SurgeContactUrl,--CONVERT(VARCHAR, --EmailGeneratedDate, 106),
					MarketingListCreateDate, Country,Url,MarketingListName,MarketinglistId,Senioritylevel,
					ExportStatus
		END
		ELSE
		BEGIN
			SELECT TOP 50
				Id,
				Gender,
				FirstName,
				LastName,
				Username,
				[Name],
				Designation,
				Organization,
				Revenue,
				EmployeeCount,
				Functionality,
				WebsiteUrl,
				Domain,
				industryName,
				EmailId,
				null as Phone,
				NULL as TimeZone,
				LinkedinId,
				SurgeContactUrl, --EmailGeneratedDate,
				MarketingListCreateDate, 
				Country,
				[Url],
				MarketingListName,
				MarketinglistId,
				senioritylevel,
				NULL as SharingStatus,
				@TargetPersonaId as TargetPersonaId,
				@TargetPersonaType as TargetPersonaType
			FROM #tempProfile
		END
	END
