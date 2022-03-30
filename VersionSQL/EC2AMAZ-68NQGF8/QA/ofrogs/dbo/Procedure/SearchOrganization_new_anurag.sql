/****** Object:  Procedure [dbo].[SearchOrganization_new_anurag]    Committed by VersionSQL https://www.versionsql.com ******/

--exec SearchOrganization_new 1,'','','125','','','AWS','','',''
CREATE PROCEDURE [dbo].[SearchOrganization_new_anurag]
    @UserId int = 0,
    @Name varchar(150) = NULL,
    @IndustryIds varchar(max) = '',
    @CountryIds varchar(max) = '',
    @EmployeeCounts varchar(max) = '',
    @Revenues varchar(8000) = '',
    @TechnTagids varchar(8000) = '',
    -- additional filter for tagid from technographics
    @GicCountryIds varchar(8000) = '',
    -- additional filter for GIC Country Organizations
    @Segment varchar(8000) = '',
    -- Additional Filter For Segment (Sub Marketing List Name)
    @Coe varchar(8000) = '',
	-- Additional filter for Organization with Coe
	@JobPostingRange varchar(8000) = '',
	-- Additional filter for Organizations with Job Postings
	@IsOutSourcing bit = 0,
	-- Additional filter for Organizations who can outsource work based on Indian Decision Makers
	@Startups bit = 0
	-- Additional filter for Startup Organizations with Startups Funding Data
AS
/*
exec SearchOrganization_anurag 1,'','4','13','10K-50K, 50K-100K','','','','',''
exec SearchOrganization_new2 1,'','4','13','10K-50K, 50K-100K','','','','',''
exec SearchOrganization_anurag 1,'','106','125','10K-50K, 50K-100K','','','','',''
exec SearchOrganization_new 1,'','106','125','10K-50K, 50K-100K','','','','',''

select *From industry

exec [SearchOrganization_new_anurag] 1,'','','13','10K-50K, 50K-100K','','.net','','Account Management',''


exec SearchOrganization_anurag 316,'','','','','','','13','','Analytics'
exec SearchOrganization_anurag 316,'','','','','500M-1B,>1B','','','',''
exec SearchOrganization_anurag 316,'','','','','','Python,java','','',''
exec SearchOrganization_anurag 316,'','','','','','','','Field Sales,Account Management',''
exec SearchOrganization_new 316,'','6,106,24,105,123,103,14,9,19,100,98,85,82,93,1',125,'100-250,1K-10K,250-1000','100M-250M,10M-50M,250M-500M,500M-1B,50M-100M,	AWS
exec SearchOrganization_anurag 316,'','','','10K-50K, 50K-100K','','','','',''
exec SearchOrganization_anurag 316,'','105,106','','','','','','',''

exec SearchOrganization_anurag 316,'','','','','','','','','Intelligent Automation'
exec SearchOrganization_anurag 316,'','','','','','','','','Intelligent Automation,Big Data,Analytics'
exec SearchOrganization_anurag 316,'','','','','','','13','','Analytics'
exec SearchOrganization_anurag 316,'','','','','','','13','','Intelligent Automation'
exec NewFilter_Test2 316,'','','125','','','','','','','0-50,50-100','','' --> JobPostingRange
exec NewFilter_Test2 316,'','','125','','','','','','','','1','' --> IsOutsourcing
exec NewFilter_Test2 316,'','','125','','','','','','','','','1' --> Startups
*/
BEGIN
    SET NOCOUNT ON
    DECLARE @SeqNum int, @NoOfAdvanceFilters int = 0, @AppRoleID int

	INSERT INTO CompanySearches(UserId,OrganizationName,IndustryIds,CountryIds,EmployeeCounts,Revenues,TechnologyNames,GicCountryIds,Teams,COEs) 
	VALUES (@UserId,  
						@Name,
						@IndustryIds,
						@CountryIds,
						@EmployeeCounts,
						@Revenues,
						@TechnTagids,
						@GicCountryIds,
						@Segment,
						@Coe);

    CREATE TABLE #TempResult
    (
        Id INT,
        [Name] VARCHAR(1000),
        [Description] VARCHAR(MAX),
        WebsiteUrl VARCHAR(200),
		Domain VARCHAR(200),
        SeqNum int,
        CountryName VARCHAR(4000),
        IndustryName VARCHAR(4000),
        Revenue VARCHAR(4000),
        EmployeeCount VARCHAR(4000),
		TeamName VARCHAR(4000),
		TechnologyName VARCHAR(4000),
		Gic VARCHAR(4000)
    )

    -- Unique Sequence Number So that the front end use this number for querying graph. This  Sequence Number is out parameter
    SELECT @SeqNum = NEXT VALUE FOR Seq_Targetpersona;

    -- Count the Number Of Advance Filters Selected Start
    IF @TechnTagids <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
    IF @GicCountryIds <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
    IF @Segment <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
    IF @Coe <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
	IF @JobPostingRange <> ''
	SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
	IF @IsOutSourcing <> 0
	SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
	IF @Startups <> 0
	SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
    -- Count the Number Of Advance Filters Selected End

    CREATE TABLE #TempOrganization
    (
        OrganizationId int,
        CountryID int
    )

    -- Decide whether the user is demo account or normal account, needed to restrict number of rows passed to front end
    SELECT @AppRoleID = AppRoleID
    FROM AppUser
    WHERE Id = @UserId
    Declare @Limit int = IIF(@AppRoleID = 3, 50, 5000)

    -- Segment Filter (Sub Marketing List Name)
    IF @Segment <> ''
    BEGIN
		select [Keyword] as TeamName into #SearchTeams from McDecisionmaker where [Name] in (SELECT value FROM STRING_SPLIT(@Segment, ','))

        INSERT INTO #TempOrganization
            (OrganizationId, CountryID)
        SELECT DISTINCT
            o.Id OrganizationId,
            o.countryid
        FROM Organization o WITH (NOLOCK)
            inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE 
			ot.TeamName IN (SELECT TeamName FROM #SearchTeams)
			AND (@CountryIds = '' OR ot.CountryId in (SELECT value FROM STRING_SPLIT(@CountryIds, ',')))
			-- (ot.CountryId) IN (Select [CountryId] from UserTargetCountry WHERE UserId = @UserId)
    END
    
    -- Technology Filter
    IF @TechnTagids <> ''
    BEGIN
        SELECT value Technology
        INTO #TempTech
        FROM STRING_SPLIT(@TechnTagids, ',')

        INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
        SELECT DISTINCT
            --tagorg.OrganizationId,
			o.Id as OrganizationId, -- Added By Neeraj ON 22/12/2020
            o.countryid
        FROM Technographics tech WITH (NOLOCK),
            --tag tagorg WITH (NOLOCK),
            organization o WITH (NOLOCK)
        WHERE 
			tech.OrganizationId = o.Id -- Added By Neeraj ON 22/12/2020
	        --tech.TagIdOrganization = tagorg.Id
            --AND tagorg.OrganizationID = o.id
            AND (tech.keyword IN (SELECT
                StacktechnologyName
            from techStackTechnology
            where StacktechnologyName in(select technology
            from #TempTech))
     )
        drop table #TempTech
    END

    -- GIC Organization Filter
    IF @GicCountryIds <> ''
    INSERT INTO #TempOrganization
	(OrganizationId, CountryID)
    SELECT DISTINCT
        OrganizationId,
        o.countryid
    FROM GicOrganization gic
        inner join organization o WITH (NOLOCK) on (gic.OrganizationId = o.id)
		inner join country c on (c.ID = gic.CountryID)
        where gic.CountryID IN (SELECT
            value
        FROM STRING_SPLIT(@GicCountryIds, ','))

    -- COE Organization Filter
    IF @Coe <> ''
    BEGIN
        declare @CoeCount int = len(@COE)-len(replace(@coe,',','')) + 2
        ;
        with
            cte1
            as
            (
                select l.OrganizationId as id, count(distinct(m.name)) as "No of MarketingList"
                from LinkedInData l WITH (NOLOCK), McDecisionmakerlist m WITH (NOLOCK)
                where m.DecisionMakerId = l.id
                    and l.TagId <> 0
                    and (m.Name = 'Centre Of Excellence' or (m.name in (SELECT value
                    FROM STRING_SPLIT(@Coe, ','))))
                group by l.OrganizationId
                having count(distinct(m.name)) = @CoeCount
            )
        INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
        SELECT distinct
            o.id as OrganizationId,
            o.countryid
        FROM cte1 tc INNER JOIN organization o with (nolock) on (o.id = tc.id)
    END

	-- Job Posting range filter

	IF @JobPostingRange <> ''
	BEGIN
		INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
		SELECT	DISTINCT
				OrganizationId,
				CountryId -- Heaquarter
		FROM	OrganizationJobPostingDetail
		WHERE	NumberOfJobPostingRange IN
				(SELECT value FROM STRING_SPLIT(@JobPostingRange, ','))
				
	END

	-- Outsourcing filter

	IF @IsOutSourcing <> 0
	BEGIN
		INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
		SELECT DISTINCT
				o.Id OrganizationId,
				o.countryid
        FROM	Organization o WITH (NOLOCK)
				inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE  ot.IsOutSourcing = 1
				 AND (@CountryIds = '' OR ot.CountryId in (SELECT value FROM STRING_SPLIT(@CountryIds, ',')))

				--(ot.CountryId) IN (Select CountryId from UserTargetCountry WHERE UserId = @UserId)
				--AND (ot.TeamName) IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId)
				--AND ot.IsOutSourcing = 1
	END

	-- StartUps Filter
	IF @Startups <> 0
	BEGIN
		INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
		SELECT	DISTINCT
				o.Id as OrganizationId,
				o.CountryId
		FROM	Organization o
				Inner Join StartUpsFundingData s on (o.Id = s.OrganizationId)
		WHERE	
		(@CountryIds = '' OR o.CountryId in (SELECT value FROM STRING_SPLIT(@CountryIds, ',')))
		-- o.CountryId IN (Select CountryId from UserTargetCountry WHERE UserId = @UserId)
	END


    -- If Advance Filters are more than one, then we have to select common organizations amongst all 
    -- And ignore other organizations and pass these organizations to the main filter of organization table
    -- viz.. Country, Industry, Revenue and Employee Count
    CREATE TABLE #TempChkOrganization
    (
        OrganizationID int,
        NoofRecords int
    )
    print 'Advance Filter Count :-' + str(@NoOfAdvanceFilters)

    IF @NoOfAdvanceFilters > 1
    BEGIN
        INSERT INTO #TempChkOrganization
        SELECT
            OrganizationId,
            COUNT(*)
        FROM #TempOrganization
        GROUP BY OrganizationId
        HAVING COUNT(*) >= @NoOfAdvanceFilters

        DELETE FROM #TempOrganization
        WHERE OrganizationId NOT IN (SELECT
            OrganizationId
        FROM #TempChkOrganization)
    END

  --  CREATE TABLE #DecisionMakers
  --  (
  --      OrganizationId int,
  --      DecisionMakersCount int
  --  )

  --  INSERT INTO #DecisionMakers
  --      (OrganizationId, DecisionMakersCount)
  --  SELECT
  --      li.OrganizationId OrganizationId,
  --      COUNT(1) AS DecisionMakersCount
  --  FROM linkedindata li WITH (NOLOCK),
  --      McDecisionmakerlist mc WITH (NOLOCK)
  --  WHERE 
  --      Li.id = mc.decisionmakerid
  --      --        AND mc.mode = 'keyword based list'
  --      AND (@CountryIds = '' OR li.ResultantCountryId in (SELECT value FROM STRING_SPLIT(@CountryIds, ',')))
		----IN (Select Countryid
  ----      from UserTargetCountry
  ----      WHERE UserId = @UserId)
  --      AND mc.name  IN (Select Functionality
  --      from UserTargetFunctionality
  --      WHERE UserId = @UserId )
  --  GROUP BY li.OrganizationId

    --- If No Advanced Filter Selected.//
    IF @TechnTagids = '' AND @GicCountryIds = '' AND @Segment = '' AND @Coe = '' AND @JobPostingRange = '' AND @IsOutSourcing = 0 AND @Startups = 0
	BEGIN
        INSERT INTO #TempResult
            (Id,
            [Name],
            [Description],
            WebsiteUrl,
			Domain,
            SeqNum,
            CountryName,
            IndustryName,
            Revenue,
            EmployeeCount )
        SELECT TOP (@Limit)
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            O.WebsiteUrl,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
            @SeqNum SeqNum,
            c.name,
            i.name,
            o.Revenue,
            o.EmployeeCount
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
            --INNER JOIN #DecisionMakers D ON (O.Id = D.OrganizationId)
        WHERE o.Name LIKE @Name + '%'
            AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')))
            AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')))
            AND (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')))
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')))
        ORDER BY Revenue DESC

    END

    -- Advance Filter Selected
    IF @TechnTagids <> '' OR @GicCountryIds <> '' OR @Segment <> '' OR @Coe <> '' OR @JobPostingRange <> '' OR @IsOutSourcing <> 0 OR @Startups <> 0
    BEGIN
        WITH
            cte
            AS
            (
                SELECT DISTINCT
                    OrganizationID
                FROM #TempOrganization
            )
        INSERT INTO #TempResult
            (Id,
            [Name],
            [Description],
            WebsiteUrl,
			Domain,
            SeqNum,
            CountryName,
            IndustryName,
            Revenue,
            EmployeeCount)
        SELECT TOP (@Limit)
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            O.WebsiteUrl,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
            @SeqNum SeqNum,
            c.name,
            i.name,
            o.Revenue,
            o.EmployeeCount
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
           -- INNER JOIN #DecisionMakers D ON (O.Id = D.OrganizationId)
            INNER JOIN cte ON o.id = cte.OrganizationId
        WHERE 
            o.Name LIKE @Name + '%'
            AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
            AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
            AND (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
        ORDER BY Revenue DESC
    END
	 Declare @personatypeids varchar(44)
	 --Select @UserId = CreatedBy From TargetPersona where id = 29815
	 Select @PersonaTypeIds = PersonaIds From Appuser where id = @UserId
	Select Functionality into #functionalities from AdoptionFramework 
	where PersonaTypeId in (select value from string_split(@PersonaTypeIds, ','))
	select OrganizationId, STRING_AGG('cloud', ',') as Teams into #Teams from cache.OrganizationTeams 
	where OrganizationId in (select Id from #TempResult)
	and TeamName in ('cloud')
	group by OrganizationId

	select OrganizationId, STRING_AGG(Keyword, ',') as Technologies into #Technologies from dbo.Technographics 
	where OrganizationId in (select Id from #TempResult)
	group by OrganizationId

	select OrganizationId, STRING_AGG(C.[Name], ',') as GicCountries into #Gic 
	from dbo.GicOrganization G
		inner join Country C on (G.CountryID = C.Id)
	where G.OrganizationId in (select Id from #TempResult)
	group by OrganizationId

	SELECT top (@Limit)
		R.*,
		OT.Teams,
		T.Technologies,
		G.GicCountries
	FROM 
		#TempResult R
		left join #Teams OT WITH (NOLOCK) on (OT.OrganizationId = R.Id)
		left join #Technologies T on (R.Id = T.OrganizationId)
		left join #Gic G on (R.Id = G.OrganizationID)

	-- exec [SearchOrganization_new_anurag] 1,'','','13','10K-50K, 50K-100K','','.net','','Account Management',''

    -- Graph Data starts
    INSERT INTO StgGraphTargetPersona
        (SequenceNo, DataType, DataString, DataValue)
                    SELECT
            @SeqNum, 'HQ', CountryName, COUNT(1)
        FROM #TempResult
        GROUP BY CountryName
    UNION
        SELECT
            @SeqNum, 'Industry', IndustryName, COUNT(1)
        FROM #TempResult
        GROUP BY IndustryName
    UNION
        SELECT
            @SeqNum, 'Revenue', Revenue, COUNT(1)
        FROM #TempResult
        GROUP BY Revenue
    UNION
        SELECT
            @SeqNum, 'Emp Count', EmployeeCount, COUNT(1)
        FROM #TempResult
        GROUP BY EmployeeCount

    DROP TABLE #TempOrganization
    DROP TABLE #TempChkOrganization
END
