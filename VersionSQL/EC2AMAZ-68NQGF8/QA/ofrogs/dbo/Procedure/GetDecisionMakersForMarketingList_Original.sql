/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList_Original]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[GetDecisionMakersForMarketingList_Original]
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

-- Taking first marketinglistid after modification in DecisionMakersForMarketingList table
	DECLARE @ModifiedMarketingListId int = 8169
	DECLARE @TargetPersonaId int
	DECLARE @TargetPersonaType varchar(10)
	Select @TargetPersonaId = TargetPersonaId from MarketingLists where id = @marketingListId
	Select @TargetPersonaType = [Type] from TargetPersona where id = @TargetPersonaId

	IF @MarketingListId < @ModifiedMarketingListId
	BEGIN
		SELECT DISTINCT
			li.url as Id,
			li.Gender,
			li.FirstName,
			li.LastName,
			li.[Name] + ', ' + li.Designation AS Username,
			li.[Name],
			li.Designation,
			o.name AS Organization,
			o.Revenue,
			o.EmployeeCount,
			mc.Name AS Functionality2,
		    O.WebsiteUrl, 
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
			i.name AS industryName,
		    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(s.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
		    s.Phone ,
			IIF(li.ResultantCountryId = 125,c.TimeZone,NULL) as TimeZone,
			s.LinkedinId,
			s.url as SurgeContactUrl,
			--CONVERT(VARCHAR, s.EmailGeneratedDate, 106) as EmailGeneratedDate,
			CONVERT(VARCHAR, ml.CreateDate, 106) as MarketingListCreateDate,
			RTRIM(li.ResultantCountry) AS Country,
			li.[Url],
			ml.MarketingListName,
			ml.id as MarketinglistId,
			li.senioritylevel

		INTO #Temp1
		FROM
			dbo.LinkedInData li WITH (NOLOCK)
			INNER JOIN dbo.Organization o with (nolock)
			ON (o.id = li.organizationid)
			INNER JOIN dbo.MarketingLists ml with (nolock)
			ON (ml.id = @MarketingListId)
			INNER JOIN dbo.Industry i with (nolock)
			ON (o.industryid = i.Id)
			INNER JOIN dbo.McDecisionMakerList mc WITH (NOLOCK)
			ON (li.Id = mc.DecisionMakerId)
			LEFT OUTER JOIN SurgeContactDetail s WITH (NOLOCK)
			--ON (li.id = s.linkedinId   --commented by asef on 16/03/20
			ON (li.uniqueid = s.uniqueid)
				--AND s.UserId = @UserId)  --commented by asef on 13/07/21
			LEFT OUTER Join CountryTimeZone c
			ON (CAST(TRIM(substring(Replace(Replace(Replace(Replace(Replace(s.Phone,' ',''),'-',''),'+',''),'(',''),')',''),2,3)) as varchar(4))
			= CAST(c.AreaCode as varchar(4)))
		WHERE li.id IN (SELECT
				DecisionMakerId
			FROM DecisionMakersForMarketingList WITH (NOLOCK)
			WHERE MarketingListId = @MarketingListId)
			-- added condition -----
			and mc.Name IN (select Functionality from MarketingListFunctionality WITH (NOLOCK)
			where MarketingListId = @MarketingListId)


		DELETE #temp1
	  WHERE Country
		NOT IN (SELECT
			Name
		FROM MarketingListCountry U,
			Country C
		WHERE u.MarketingListId = @MarketingListId
			AND u.countryid = c.id)

		DELETE #temp1
	  WHERE senioritylevel
		NOT IN ((SELECT
			seniority
		FROM UserTargetSeniority
		WHERE userid = @UserId))


		-- Commented by Neeraj on 21/12/2020

	   -- select distinct MC.decisionmakerid, MC.Name
	   -- into #DecisionMakers
	   -- from dbo.McDecisionmakerlist MC 
			 --inner join #Temp1 T on (T.Id = MC.DecisionMakerId)
			 --inner join MarketingListFunctionality ml on (ml.Functionality = mc.Name and ml.MarketingListId = @MarketingListId)
		 
		-- dbo.McDecisionMakerList mc1 with (nolock)
		-- where mc1.decisionmakerid = mc.decisionmakerid) mc2

		IF @AppRoleID <> 3
		BEGIN
		print 'part 0'
		SELECT	DISTINCT 
				T.Id, 
				T.Gender,
			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(T.FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
			  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(T.LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(T.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,

				T.Username, T.Name, T.Designation, T.Organization, T.Revenue, 
				T.EmployeeCount,
				string_agg(T.Functionality2,',') as Functionality,
				T.WebsiteUrl, T.Domain,
				T.IndustryName, 
				--ISNULL(T.EmailId,'') as EmailId, 

				T.Phone,T.TimeZone, T.LinkedinId, T.SurgeContactUrl, 
				T.MarketingListCreateDate, T.Country, T.Url,T.MarketingListName, T.MarketinglistId,T.Senioritylevel,
				IIF(h.Url IS NOT NULL,'Exported','Not Exported') as ExportStatus,
				@TargetPersonaId as TargetPersonaId,
				@TargetPersonaType as TargetPersonaType

		FROM	#temp1 T
				LEFT JOIN HubSpotSharedProfiles h ON (T.Url = h.Url AND h.UserId = @UserId)
		-- Added by Neeraj on 21/12/2020
		Group By T.Id,
		T.Gender, T.FirstName, T.LastName, T.Username, T.Name, T.Designation, T.Organization, T.Revenue, T.EmployeeCount,
		T.WebsiteUrl, T.Domain, T.IndustryName, ISNULL(T.EmailId,''), T.Phone,T.TimeZone, T.LinkedinId, T.SurgeContactUrl, 
		T.MarketingListCreateDate, T.Country, T.Url,T.MarketingListName, T.MarketinglistId,T.Senioritylevel,
		IIF(h.Url IS NOT NULL,'Exported','Not Exported')
		--ORDER BY EmailGeneratedDate desc
	  END
	  ELSE
	  BEGIN
			-- Janna 17 Oct 2019 changed * to columns to show emailid as hidden for Demo account
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
			Functionality2 as Functionality,
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

		FROM #temp1
	END
	END
	ELSE
	BEGIN
	print 'else part1'
		SELECT	DISTINCT 
				d.LinkedInUrl as Id,
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

END
