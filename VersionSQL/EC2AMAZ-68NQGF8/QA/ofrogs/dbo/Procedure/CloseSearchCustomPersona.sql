/****** Object:  Procedure [dbo].[CloseSearchCustomPersona]    Committed by VersionSQL https://www.versionsql.com ******/

-- EXEC [CloseSearchCustomPersona] '','','anDROID'
 CREATE PROCEDURE [dbo].[CloseSearchCustomPersona] 
    @TechnTagids varchar(8000) = '',
    @Segment varchar(8000) = '',
	@Functionalities varchar(8000) = ''

AS
BEGIN
    SET NOCOUNT ON

    DECLARE @SeqNum int, @NoOfAdvanceFilters int = 0, @AppRoleID int, @CustomerType varchar(20)

 




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





    CREATE TABLE #TempOrganization
    (
        OrganizationId int,
        CountryID int
    )

    -- Segment Filter (Sub Marketing List Name)
    IF @Segment <> ''
    BEGIN

        INSERT INTO #TempOrganization
            (OrganizationId, CountryID)
        SELECT DISTINCT
            o.Id OrganizationId,
            o.countryid
        FROM Organization o WITH (NOLOCK)
            inner join cache.OrganizationTeams ot WITH (NOLOCK) on (ot.OrganizationId = o.Id)
        WHERE 
			ot.TeamName IN (SELECT value FROM STRING_SPLIT(@Segment, ','))
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

   -- new @Functionalities
   IF @Functionalities <> ''
    BEGIN
	 INSERT INTO #TempOrganization
		(OrganizationId, CountryID)
		SELECT distinct O.ID, O.countryid
		FROM Organization O
		INNER JOIN SurgeSummary S 
		ON S.OrganizationID = O.ID
		WHERE S.Functionality IN (SELECT value FROM STRING_SPLIT(@Functionalities, ','))
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

    


   


       ; WITH
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
            CountryName,
            IndustryName,
            Revenue,
            EmployeeCount)
        SELECT 
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            O.WebsiteUrl,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
            
            c.name,
            i.name,
            o.Revenue,
            o.EmployeeCount
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
            INNER JOIN cte ON o.id = cte.OrganizationId
         
            
             
  

			SELECT DISTINCT
					id
			FROM #TempResult

			DROP TABLE #TempOrganization
			DROP TABLE #TempChkOrganization
			END
		
