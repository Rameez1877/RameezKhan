/****** Object:  Procedure [dbo].[SearchOrganization_orginal]    Committed by VersionSQL https://www.versionsql.com ******/

--exec [SearchOrganization_orginal] 1,'','','','','','','','','','','','',''
CREATE PROCEDURE [dbo].[SearchOrganization_orginal]
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
	@Startups bit = 0,
	-- Additional filter for Startup Organizations with Startups Funding Data
	-- @IsDashboardUser bit = 0
	@Functionalities varchar(8000) = ''
AS
/*
exec SearchOrganization_dashboard 159,'','6','','','','','','','','',0,0
exec SearchOrganization_new 159,'','6','','','','','','','','',0,0,1

exec SearchOrganization_dashboard 5727,'','6','13','','','','','','','',0,0
exec SearchOrganization_dashboard 159,'','','','','','GitHub','','DevOps','','',0,0
*/
BEGIN
    SET NOCOUNT ON

    DECLARE @SeqNum int, @NoOfAdvanceFilters int = 0, @AppRoleID int, @IsNewUSer BIT
	select @IsNewUSer = IsNewUser from AppUser where id = @UserId

    -- Decide whether the user is demo account or normal account, needed to restrict number of rows passed to front end
    SELECT @AppRoleID = AppRoleID
    FROM AppUser
    WHERE Id = @UserId
    Declare @Limit int = IIF(@AppRoleID = 3, 200, 5000)

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


	IF @IsNewUSer = 1 
	BEGIN
	print 'new user = true'

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

    -- Segment Filter (Sub Marketing List Name)
    IF @Segment <> ''
    BEGIN
		-- select [Name] as TeamName into #SearchTeams from McDecisionmaker where [Name] in (SELECT value FROM STRING_SPLIT(@Segment, ','))

        INSERT INTO #TempOrganization
            (OrganizationId, CountryID)
        SELECT DISTINCT
            o.Id OrganizationId,
            o.countryid
        FROM Organization o WITH (NOLOCK)
            inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE 
			ot.TeamName IN (SELECT value FROM STRING_SPLIT(@Segment, ','))
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

			SELECT top (@Limit)
					*
			FROM #TempResult

			DROP TABLE #TempOrganization
			DROP TABLE #TempChkOrganization

			END -- ISDASHBOARDUSER END

	--		IF @IsNewUSer = 0  
 --   OR @IndustryIds <> ''
 --   OR @CountryIds <> ''
 --   OR @EmployeeCounts <> ''
 --   OR @Revenues <> ''
 --   OR @TechnTagids <> ''
 --   OR @GicCountryIds <> ''
 --   OR @Segment <> ''
	--OR @Functionalities <> ''
	ELSE 
				BEGIN
			PRINT 'new user = false'
			create table #tempGIC (organizationId int)
			IF @GicCountryIds <> ''
			begin
			insert into #tempGIC (organizationId)
			SELECT  DISTINCT 
				d.id
				-- o.countryid
			FROM DashboardSummary d WITH (NOLOCK)
				inner join GicOrganization gic WITH (NOLOCK) on (gic.OrganizationId = d.id)
				--inner join country c on (c.ID = gic.CountryID)
				where gic.CountryID IN (SELECT
					value
				FROM STRING_SPLIT(@GicCountryIds, ','))
			
			END
			SELECT DISTINCT top (@Limit)
				O.ID,
				O.[NAME],
				O.WebsiteUrl,
				SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
				LEN(O.WebsiteUrl)) AS [Domain],
				O.EmployeeCount,
				O.Revenue,
				O.IndustryID,
				I.NAME IndustryName,
				O.CountryId,
				CO.Name CountryName,
				O.WebsiteDescription
			FROM 
		organization o
		inner join DashboardUserIndustry i on (i.id = o.IndustryId AND i.UserID = @UserId)
		INNER JOIN DashboardUserCountry CO ON (CO.ID = O.CountryId AND CO.UserID = @UserId)
		left JOIN  DashboardUserTeam c ON (o.Id = c.OrganizationId AND C.UserID = @UserId)
		left join  DashboardUserTechnology t on (o.id =t.OrganizationId AND T.UserID = @UserId )
		left join DashboardUserSurge s on (o.id = s.OrganizationId AND S.UserID = @UserId )
	where o.id in
	 (select organizationid from DashboardUserTeam WHERE UserID = @UserId union 
		select organizationid from DashboardUserTechnology WHERE UserID = @UserId
		union 
		select organizationid from DashboardUserSurge WHERE UserID = @UserId
	)
	 
            AND (@IndustryIds = ''
            OR I.NAME IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryIds, ',')) )
            AND (@CountryIds = ''
            OR CO.NAME IN (SELECT
                value
            FROM STRING_SPLIT(@CountryIds, ',')) )
            AND (@EmployeeCounts = ''
            OR EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCounts, ',')) )
            AND (@Revenues = ''
            OR Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenues, ',')) )
			AND (@Segment = ''
            OR TeamName IN (SELECT
                value
            FROM STRING_SPLIT(@Segment, ',')) )
			AND (@TechnTagids = ''
            OR T.KEYWORD IN (SELECT
                value
            FROM STRING_SPLIT(@TechnTagids, ',')) )
			AND (@GicCountryIds = ''
            OR O.Id IN (SELECT OrganizationId from #tempGIC))
			AND (@Functionalities = ''
            OR Functionality IN (SELECT
                value
            FROM STRING_SPLIT(@Functionalities, ',')) )
			drop table #tempGIC
 END


--SELECT DISTINCT D.ID,D.NAME,D.WebsiteUrl,D.EmployeeCount,D.Revenue,D.IndustryID,D.IndustryName,D.CountryId,D.CountryName,D.WebsiteDescription
--	FROM DashboardSummary D
--	WHERE UserID = @UserId
--	AND 
--	D.IndustryID  IN (SELECT
--                value
--            FROM STRING_SPLIT(@IndustryIds, ',')) 

--			UNION

-- SELECT DISTINCT D.ID,D.NAME,D.WebsiteUrl,D.EmployeeCount,D.Revenue,D.IndustryID,D.IndustryName,D.CountryId,D.CountryName,D.WebsiteDescription
--	FROM DashboardSummary D
--	WHERE UserID = @UserId
--	AND 
--	D.CountryId  IN (SELECT
--                value
--            FROM STRING_SPLIT(@CountryIds, ','))

--			UNION

--			SELECT DISTINCT D.ID,D.NAME,D.WebsiteUrl,D.EmployeeCount,D.Revenue,D.IndustryID,D.IndustryName,D.CountryId,D.CountryName,D.WebsiteDescription
--	FROM DashboardSummary D
--	WHERE UserID = @UserId
--            AND D.EmployeeCount IN (SELECT
--                value
--            FROM STRING_SPLIT(@EmployeeCounts, ',')) 

--           UNION

--		   SELECT DISTINCT D.ID,D.NAME,D.WebsiteUrl,D.EmployeeCount,D.Revenue,D.IndustryID,D.IndustryName,D.CountryId,D.CountryName,D.WebsiteDescription
--	FROM DashboardSummary D
--	WHERE UserID = @UserId

--            AND D.Revenue IN (SELECT
--                value
--            FROM STRING_SPLIT(@Revenues, ',')) 
			--END

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

    


END
