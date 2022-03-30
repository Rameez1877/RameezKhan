/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList_neeraj]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList_neeraj]
    @MarketingListId int,
    @UserId int
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

    SELECT DISTINCT
        li.Id,
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
        case when O.WebsiteUrl like'%https%' or O.WebsiteUrl like'%http%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
        i.name AS industryName,
        s.EmailId,
        CASE 
			WHEN 
				(s.Phone IS NOT NULL AND s.Phone <> '')
			THEN
				'+' + substring(Replace(Replace(Replace(Replace(Replace(s.Phone,' ',''),'-',''),'+',''),'(',''),')',''),1,3) + ' ' 
				+ substring(Replace(Replace(Replace(Replace(Replace(s.Phone,' ',''),'-',''),'+',''),'(',''),')',''),4,4) + ' ' +
				substring(Replace(Replace(Replace(Replace(Replace(s.Phone,' ',''),'-',''),'+',''),'(',''),')',''),8,50) 
		ELSE 
			s.Phone 
		END as Phone,
		IIF(li.ResultantCountryId = 125,c.TimeZone,NULL) as TimeZone,
        s.LinkedinId,
        s.url as SurgeContactUrl,
        CONVERT(VARCHAR, s.EmailGeneratedDate, 106) as EmailGeneratedDate,
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
        ON (li.url = s.url
            AND s.UserId = @UserId)
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
    SELECT distinct 
        Id, Gender, FirstName, LastName, Username, [Name], Designation, Organization, Revenue, EmployeeCount,
        --REPLACE
        --(REPLACE
        --(STUFF
        --(
        --(SELECT ', ' + [Name]
        --from (select distinct [Name]
        --    from
        --        #DecisionMakers D
        --    where D.decisionmakerid = T.Id) mc2
        --FOR XML PATH ('')
        --)
        --, 1, 1, ''), '&amp;', '&'), '''', '') AS Functionality,
		string_agg(Functionality2,',') as Functionality,
        WebsiteUrl,
        industryName, EmailId, Phone, TimeZone, LinkedinId, SurgeContactUrl, EmailGeneratedDate, MarketingListCreateDate, Country, [Url],
        MarketingListName, MarketinglistId,
        senioritylevel
    FROM #temp1 T
	-- Added by Neeraj on 21/12/2020
	Group By Id, Gender, FirstName, LastName, Username, [Name], Designation, Organization, Revenue, EmployeeCount,
	WebsiteUrl,industryName, EmailId, Phone, TimeZone, LinkedinId, SurgeContactUrl, EmailGeneratedDate, MarketingListCreateDate, Country, [Url],
    MarketingListName, MarketinglistId,senioritylevel
    order by EmailGeneratedDate desc
  ELSE
        -- Janna 17 Oct 2019 changed * to columns to show emailid as hidden for Demo account
        SELECT TOP 15
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
        industryName,
        '**********' EmailId,
        null as Phone,
		NULL AS TimeZone,
        LinkedinId,
        SurgeContactUrl, EmailGeneratedDate, MarketingListCreateDate, 
        Country,
        [Url],
        MarketingListName,
        MarketinglistId,
        senioritylevel
    FROM #temp1

END
