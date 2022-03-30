/****** Object:  Procedure [dbo].[NewFilter_Test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[NewFilter_Test]
    @UserId int = 0,
    @Name varchar(150) = NULL,
    @IndustryIds varchar(8000) = '',
    @CountryIds varchar(8000) = '',
    @EmployeeCounts varchar(8000) = '',
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
exec SearchOrganization_anurag 316,'','','','','','Oracle Fusion','13','',''
exec SearchOrganization_anurag 316,'','','','','','','13','','Analytics'
exec SearchOrganization_anurag 316,'','','','','500M-1B,>1B','','','',''
exec SearchOrganization_anurag 316,'','','','','','Python,java','','',''
exec SearchOrganization_anurag 316,'','','','','','','','Field Sales,Account Management',''
exec SearchOrganization_anurag 316,'','','13,125','','','','','',''
exec SearchOrganization_anurag 316,'','','','10K-50K, 50K-100K','','','','',''
exec SearchOrganization_anurag 316,'','105,106','','','','','','',''

exec SearchOrganization_anurag 316,'','','','','','','','','Intelligent Automation'
exec SearchOrganization_anurag 316,'','','','','','','','','Intelligent Automation,Big Data,Analytics'
exec SearchOrganization_anurag 316,'','','','','','','13','','Analytics'
exec SearchOrganization_anurag 316,'','','','','','','13','','Intelligent Automation'
*/
BEGIN
    SET NOCOUNT ON
    DECLARE @SeqNum int, @NoOfAdvanceFilters int = 0, @AppRoleID int

    CREATE TABLE #TempResult
    (
        Id INT,
        [Name] VARCHAR(1000),
        [Description] VARCHAR(MAX),
        WebsiteUrl VARCHAR(200),
        DecisionMakers int,
        SeqNum int,
        CountryName VARCHAR(4000),
        IndustryName VARCHAR(4000),
        Revenue VARCHAR(4000),
        EmployeeCount VARCHAR(4000)
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
    Declare @Limit int = IIF(@AppRoleID = 3, 50, 50000)

    -- Segment Filter (Sub Marketing List Name)
    IF @Segment <> ''
    BEGIN
		select [Keyword] as TeamName into #SearchTeams from McDecisionmaker where [Name] in (SELECT [Data] FROM dbo.Split(@Segment, ','))

        INSERT INTO #TempOrganization
            (OrganizationId, CountryID)
        SELECT DISTINCT
            o.Id OrganizationId,
            o.countryid
        FROM Organization o WITH (NOLOCK)
            inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE 
            --ot.TeamName IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId) 
            --AND 
			(ot.CountryId) IN (Select [CountryId] from UserTargetCountry WHERE UserId = @UserId)
           --  AND O.[Name] LIKE @Name + '%'
            AND (ot.TeamName IN (SELECT TeamName FROM #SearchTeams))

		--INSERT INTO #TempOrganization
  --          (OrganizationId, CountryID)
  --      SELECT DISTINCT
  --          li.OrganizationId OrganizationId,
  --          o.countryid
  --      FROM linkedindata li WITH (NOLOCK)
  --          inner join organization o WITH (NOLOCK) on (o.Id = li.OrganizationId)
  --          inner join McDecisionmakerlist mc WITH (NOLOCK) on (mc.DecisionMakerId = li.id)
  --      WHERE 
  --      -- mc.mode = 'keyword based list'
  --      --  AND li.SeniorityLevel IN ('C-Level', 'Director')
  --          mc.name  IN (Select Functionality
  --          from UserTargetFunctionality
  --          WHERE UserId = @UserId )--27jan2020
  --          AND (li.ResultantCountryId) IN (Select [CountryId]
  --          from UserTargetCountry
  --          WHERE UserId = @UserId)
  --          AND O.[Name] LIKE @Name + '%'
  --          AND (mc.name IN (SELECT
  --              [Data]
  --          FROM dbo.Split(@Segment, ',')))
    END
    
    -- Technology Filter
    IF @TechnTagids <> ''
    BEGIN
        SELECT [Data] Technology
        INTO #TempTech
        FROM dbo.Split(@TechnTagids, ',')

        INSERT INTO #TempOrganization
        SELECT DISTINCT
            tagorg.OrganizationId,
            o.countryid
        FROM Technographics tech WITH (NOLOCK),
            tag tagorg WITH (NOLOCK),
            organization o WITH (NOLOCK)
        WHERE 
	        tech.TagIdOrganization = tagorg.Id
            AND tagorg.OrganizationID = o.id
            AND (tech.keyword IN (SELECT
                StacktechnologyName
            from techStackTechnology
            where Stacktechnology in(select technology
            from #TempTech))
     )
        drop table #TempTech
    END

    -- GIC Organization Filter
    IF @GicCountryIds <> ''
    INSERT INTO #TempOrganization
    SELECT DISTINCT
        OrganizationId,
        o.countryid
    FROM GicOrganization gic,
        organization o WITH (NOLOCK)
    WHERE gic.OrganizationId = o.id
        AND gic.CountryID IN (SELECT
            [Data]
        FROM dbo.Split(@GicCountryIds, ','))

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
                    and (m.Name = 'Centre Of Excellence' or (m.name in (SELECT [Data]
                    FROM dbo.Split(@Coe, ','))))
                group by l.OrganizationId
                having count(distinct(m.name)) = @CoeCount
            )
        INSERT INTO #TempOrganization
        SELECT distinct
            o.id as OrganizationId,
            o.countryid
        FROM cte1 tc INNER JOIN organization o with (nolock) on (o.id = tc.id)
    END

	-- Job Posting range filter

	IF @JobPostingRange <> ''
	BEGIN
		INSERT INTO #TempOrganization
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
		SELECT DISTINCT
				o.Id OrganizationId,
				o.countryid
        FROM	Organization o WITH (NOLOCK)
				inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE  
				(ot.CountryId) IN (Select CountryId from UserTargetCountry WHERE UserId = @UserId)
				AND (ot.TeamName) IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId)
				AND ot.IsOutSourcing = 1
	END

	-- StartUps Filter
	IF @Startups <> 0
	BEGIN
		INSERT INTO #TempOrganization
		SELECT	DISTINCT
				o.Id as OrganizationId,
				o.CountryId
		FROM	Organization o
				Inner Join StartUpsFundingData s on (o.Id = s.OrganizationId)
		WHERE	o.CountryId IN (Select CountryId from UserTargetCountry WHERE UserId = @UserId)
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

    CREATE TABLE #DecisionMakers
    (
        OrganizationId int,
        DecisionMakersCount int
    )

    INSERT INTO #DecisionMakers
        (OrganizationId, DecisionMakersCount)
    SELECT
        li.OrganizationId OrganizationId,
        COUNT(1) AS DecisionMakersCount
    FROM linkedindata li WITH (NOLOCK),
        McDecisionmakerlist mc WITH (NOLOCK)
    WHERE 
        Li.id = mc.decisionmakerid
        --        AND mc.mode = 'keyword based list'
        AND (li.ResultantCountryId) IN (Select Countryid
        from UserTargetCountry
        WHERE UserId = @UserId)
        AND mc.name  IN (Select Functionality
        from UserTargetFunctionality
        WHERE UserId = @UserId )
    GROUP BY li.OrganizationId

    --- If No Advanced Filter Selected.//
    IF @TechnTagids = '' AND @GicCountryIds = '' AND @Segment = '' AND @Coe = '' AND @JobPostingRange = '' AND @IsOutSourcing = 0 AND @Startups = 0
	BEGIN
        INSERT INTO #TempResult
            (Id,
            [Name],
            [Description],
            WebsiteUrl,
            SeqNum,
            CountryName,
            IndustryName,
            Revenue,
            EmployeeCount )
        SELECT TOP (@Limit)
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
            @SeqNum SeqNum,
            c.name,
            i.name,
            o.Revenue,
            o.EmployeeCount
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
            INNER JOIN #DecisionMakers D ON (O.Id = D.OrganizationId)
        WHERE o.Name LIKE @Name + '%'
            AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                [Data]
            FROM dbo.Split(@IndustryIds, ',')))
            AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                [Data]
            FROM dbo.Split(@CountryIds, ',')))
            AND (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                [Data]
            FROM dbo.Split(@EmployeeCounts, ',')))
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                [Data]
            FROM dbo.Split(@Revenues, ',')))
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
            SeqNum,
            CountryName,
            IndustryName,
            Revenue,
            EmployeeCount)
        SELECT TOP (@Limit)
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
            @SeqNum SeqNum,
            c.name,
            i.name,
            o.Revenue,
            o.EmployeeCount
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
            INNER JOIN #DecisionMakers D ON (O.Id = D.OrganizationId)
            INNER JOIN cte ON o.id = cte.OrganizationId
        WHERE 
            o.Name LIKE @Name + '%'
            AND (@IndustryIds = ''
            OR O.IndustryId IN (SELECT
                [Data]
            FROM dbo.Split(@IndustryIds, ',')) )
            AND (@CountryIds = ''
            OR O.CountryId IN (SELECT
                [Data]
            FROM dbo.Split(@CountryIds, ',')) )
            AND (@EmployeeCounts = ''
            OR O.EmployeeCount IN (SELECT
                [Data]
            FROM dbo.Split(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR O.Revenue IN (SELECT
                [Data]
            FROM dbo.Split(@Revenues, ',')) )
        ORDER BY Revenue DESC
    END

			SELECT top (@Limit)
					*
			FROM #TempResult

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
