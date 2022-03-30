/****** Object:  Procedure [dbo].[GetAllDecisionMakersForMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAllDecisionMakersForMarketingList]
    @MarketingListId int	
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================   
/*
exec GetAllDecisionMakersForMarketingList  8771, 6121
*/
BEGIN
		
				SELECT	DISTINCT 
				 d.Gender,
				 d.[Name],
				 d.Designation,
				 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
				LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
				O.Name Organization,
				o.Id as OrganizationId,
				d.Country,d.Functionality,
				d.LinkedInUrl as [Url],
				d.Senioritylevel,
				d.EmailId,
				o.WebsiteUrl,
				o.Revenue,
				o.EmployeeCount,
				i.[Name] as IndustryName
		
		FROM	DecisionMakersForMarketingList d with (nolock)
				INNER JOIN Organization O with (nolock) ON O .Id = D.OrganizationId
				INNER JOIN Industry i ON (o.IndustryId = i.Id)
		WHERE	d.MarketingListId = @MarketingListId


		--SELECT	DISTINCT 
		--		 d.Gender, 
		--		 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
		--		 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
		--		 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
		--		 d.[Name], d.Designation,o.[Name] as Organization,
		--		 o.Revenue,o.EmployeeCount,
		--		 d.Functionality,
		--		 o.WebsiteUrl,i.[Name] as IndustryName,
		--		 IIF(d.Country = 'United States Of America',c.TimeZone,NULL) as TimeZone,
		--		 d.Country, 
		--		d.LinkedInUrl as Url,
		--		d.Senioritylevel
		--		into #tempProfile
		--FROM	DecisionMakersForMarketingList d
		--		INNER JOIN Organization o ON (d.OrganizationId = o.Id)
		--		INNER JOIN Industry i ON (o.IndustryId = i.Id)
		--		-- INNER JOIN MarketingLists m ON (d.MarketingListId = m.Id)
		--		LEFT OUTER Join CountryTimeZone c
		--		ON (CAST(TRIM(substring(Replace(Replace(Replace(Replace(Replace(d.Phone,' ',''),'-',''),'+',''),'(',''),')',''),2,3)) as varchar(4))
		--		= CAST(c.AreaCode as varchar(4)))
		--WHERE	d.MarketingListId = @MarketingListId
		--and d.EmailId <> ''

		--	SELECT DISTINCT -- top (@Limit)
		--			Gender,
		--			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(FirstName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as FirstName,
		--			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(LastName, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as LastName,
		--			 LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) as EmailId,
		--			[Name], Designation,Organization,
		--			Revenue,EmployeeCount,
		--			STRING_AGG(Functionality,',') as Functionality,
		--			WebsiteUrl, 
		--			IndustryName,
		--			TimeZone,
		--			--CONVERT(VARCHAR, EmailGeneratedDate, 106) as EmailGeneratedDate,
		--			Country, 
		--			Url,Senioritylevel

		--	FROM	#tempProfile
		--	GROUP BY Gender, FirstName,LastName,
		--			Name, Designation,Organization,Revenue,EmployeeCount,WebsiteUrl, IndustryName,EmailId,
		--			TimeZone,
		--			Country,Url,Senioritylevel
	END
