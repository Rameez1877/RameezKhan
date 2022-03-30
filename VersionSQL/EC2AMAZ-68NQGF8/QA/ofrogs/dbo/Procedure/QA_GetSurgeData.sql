/****** Object:  Procedure [dbo].[QA_GetSurgeData]    Committed by VersionSQL https://www.versionsql.com ******/

--Script Date: 18-Nov-21 - Kabir
CREATE PROCEDURE [dbo].[QA_GetSurgeData] @TargetPersonaId int

AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @AppRoleId int,
          @Limit int,
          @PersonaTypeIds varchar(500),
          @Persona varchar(100),
          @Region varchar(100),
          @UserId int,
          @EmployeeCount varchar(8000),
          @Country varchar(500),
          @Industry varchar(500),
          @Technology varchar(8000),
          @TechnologyCategory varchar(8000),
          @Revenue varchar(8000),
          @Intent varchar(8000),
          @Team varchar(8000),
          @IndustryID varchar(500),
          @GIC varchar(500),
          @Type varchar(100) 

  SELECT
    @UserId = CreatedBy,
    @EmployeeCount = EmployeeCounts,
    @Country = Locations,
    @Industry = Industries,
    @Technology = Technologies,
    @TechnologyCategory = TechnologyCategory,
    @Revenue = Revenues,
    @Intent = Intent,
    @Team = Segment,
    @IndustryID = IndustryGroupIds,
    @Persona = PersonaIds,
    @Region = Regionids,
    @GIC = Gics,
    @Type = type
  FROM TARGETPERSONA
  WHERE ID = @TargetPersonaId

  SET @Limit = IIF(@AppRoleId = 3,200,99999)

  SELECT @AppRoleId = AppRoleId
  FROM AppUser
  WHERE ID = @UserId

  IF @Type = 'App'
  BEGIN
    PRINT 'FOR APP'
    SELECT DISTINCT TOP (@Limit)
      s.Organization,
      s.OrganizationId,
      s.Industry,
      s.Functionality,
      s.Technology,
      s.TechnologyCategory,
      s.InvestmentType,
      s.CountryName,
      s.Duration,
      s.Surge,
      s.Revenue,
      s.NoOfDecisionMaker
    FROM SurgeSummary S
    INNER JOIN MobileAPP M WITH (NOLOCK)
      ON S.OrganizationId = M.OrganizationID
    INNER JOIN TargetPersonaMobileAppId MA
      ON MA.MOBILEAPPID = M.ID
      AND MA.TARGETPERSONAID = @TargetPersonaId
  END

  ELSE
  BEGIN

    SELECT
      @AppRoleId = AppRoleId
    FROM AppUser
    WHERE Id = @UserId

    SELECT
      ID,
      NAME INTO #INDUSTRYID
    FROM Industry
    WHERE INDUSTRYGROUPID IN (SELECT
      VALUE
    FROM string_split(@IndustryID, ','))
    SELECT
      ID,
      NAME INTO #COUNTRYID
    FROM Country
    WHERE IsRegion IN (SELECT
      VALUE
    FROM string_split(@REGION, ','))

    IF @GIC <> ''
    BEGIN
      PRINT 'FOR GIC'
      SELECT DISTINCT TOP (@Limit)
        s.Organization,
        s.OrganizationId,
        s.Industry,
        s.Functionality,
        s.Technology,
        s.TechnologyCategory,
        s.InvestmentType,
        s.CountryName,
        s.Duration,
        s.Surge,
        s.Revenue,
        s.NoOfDecisionMaker
      FROM SurgeSummary S
      INNER JOIN GicOrganization G WITH (NOLOCK)
        ON S.OrganizationId = G.OrganizationID
      INNER JOIN TARGETPERSONAORGANIZATION TPO
        ON TPO.TARGETPERSONAID = @TargetPersonaId
        AND TPO.ORGANIZATIONID = S.ORGANIZATIONID
      WHERE (@GIC = ''
      OR G.CountryID IN (SELECT
        value
      FROM STRING_SPLIT(@GIC, ','))
      )
      AND (@COUNTRY = ''
      OR S.CountryID IN (SELECT
        value
      FROM STRING_SPLIT(@COUNTRY, ','))
      )
      AND (@Industry = ''
      OR S.IndustryID IN (SELECT
        value
      FROM STRING_SPLIT(@Industry, ','))
      )
      AND (@TechnologyCategory = ''
      OR S.TechnologyCategory IN (SELECT
        value
      FROM STRING_SPLIT(@TechnologyCategory, ','))
      )
      AND (@EmployeeCount = ''
      OR S.EmployeeCount IN (SELECT
        value
      FROM STRING_SPLIT(@EmployeeCount, ','))
      )
      AND (@Revenue = ''
      OR S.Revenue IN (SELECT
        value
      FROM STRING_SPLIT(@Revenue, ','))
      )
      AND (@Technology = ''
      OR S.Technology IN (SELECT
        value
      FROM STRING_SPLIT(@Technology, ','))
      )
      AND (@Intent = ''
      OR S.Functionality IN (SELECT
        value
      FROM STRING_SPLIT(@Intent, ','))
      )
      AND (@TechnologyCategory = ''
      OR S.TechnologyCategory IN (SELECT
        value
      FROM STRING_SPLIT(@TechnologyCategory, ','))
      )

    END

    IF @GIC = ''
    BEGIN

      IF @Persona IS NULL
      BEGIN
        PRINT 'IF'
        SELECT DISTINCT TOP (@Limit)
          s.Organization,
          s.OrganizationId,
          s.Industry,
          s.Functionality,
          s.Technology,
          s.TechnologyCategory,
          s.InvestmentType,
          s.CountryName,
          s.Duration,
          s.Surge,
          s.Revenue,
          s.NoOfDecisionMaker
        FROM SurgeSummary S
        INNER JOIN GicOrganization G WITH (NOLOCK)
          ON S.OrganizationId = G.OrganizationID
        INNER JOIN TARGETPERSONAORGANIZATION TPO
          ON TPO.TARGETPERSONAID = @TargetPersonaId
          AND TPO.ORGANIZATIONID = S.ORGANIZATIONID
        WHERE (@GIC = ''
        OR G.CountryID IN (SELECT
          value
        FROM STRING_SPLIT(@GIC, ','))
        )
        AND (@COUNTRY = ''
        OR S.CountryID IN (SELECT
          value
        FROM STRING_SPLIT(@COUNTRY, ','))
        )
        AND (@Industry = ''
        OR S.IndustryID IN (SELECT
          value
        FROM STRING_SPLIT(@Industry, ','))
        )
        AND (@TechnologyCategory = ''
        OR S.TechnologyCategory IN (SELECT
          value
        FROM STRING_SPLIT(@TechnologyCategory, ','))
        )
        AND (@EmployeeCount = ''
        OR S.EmployeeCount IN (SELECT
          value
        FROM STRING_SPLIT(@EmployeeCount, ','))
        )
        AND (@Revenue = ''
        OR S.Revenue IN (SELECT
          value
        FROM STRING_SPLIT(@Revenue, ','))
        )
        AND (@Technology = ''
        OR S.Technology IN (SELECT
          value
        FROM STRING_SPLIT(@Technology, ','))
        )
        AND (@Intent = ''
        OR S.Functionality IN (SELECT
          value
        FROM STRING_SPLIT(@Intent, ','))
        )
        AND (@TechnologyCategory = ''
        OR S.TechnologyCategory IN (SELECT
          value
        FROM STRING_SPLIT(@TechnologyCategory, ','))
        )
      END
      ELSE
      BEGIN
        PRINT 'ELSE'
        SELECT DISTINCT TOP (@Limit)
          s.Organization,
          s.OrganizationId,
          s.Industry,
          s.Functionality,
          s.Technology,
          s.TechnologyCategory,
          s.InvestmentType,
          s.CountryName,
          s.Duration,
          s.Surge,
          s.Revenue,
          s.NoOfDecisionMaker
        FROM SurgeSummary s WITH (NOLOCK)
        INNER JOIN CACHE.ORGANIZATIONTEAMS CO
          ON CO.ORGANIZATIONID = S.ORGANIZATIONID
        INNER JOIN TARGETPERSONAORGANIZATION TPO
          ON TPO.TARGETPERSONAID = @TargetPersonaId
          AND TPO.ORGANIZATIONID = S.ORGANIZATIONID
        INNER JOIN AdoptionFrameworkTechnologyCategory AF
          ON AF.TechnologyCategory = S.TechnologyCategory
          AND (@TechnologyCategory = ''
          OR AF.TechnologyCategory IN (SELECT
            value
          FROM STRING_SPLIT(@TechnologyCategory, ','))
          )
        INNER JOIN Persona P
          ON P.Name = AF.Category
          AND p.Id IN (SELECT
            VALUE
          FROM string_split(@PERSONA, ','))
        INNER JOIN #COUNTRYID C
          ON C.ID = S.CountryID
          AND (@COUNTRY = ''
          OR C.Id IN (SELECT
            value
          FROM STRING_SPLIT(@COUNTRY, ','))
          )
        INNER JOIN #INDUSTRYID I
          ON I.ID = S.INDUSTRYID
          AND (@Industry = ''
          OR i.Id IN (SELECT
            value
          FROM STRING_SPLIT(@Industry, ','))
          )
        WHERE (@EmployeeCount = ''
        OR S.EmployeeCount IN (SELECT
          value
        FROM STRING_SPLIT(@EmployeeCount, ','))
        )
        AND (@Revenue = ''
        OR S.Revenue IN (SELECT
          value
        FROM STRING_SPLIT(@Revenue, ','))
        )
        AND (@Technology = ''
        OR S.Technology IN (SELECT
          value
        FROM STRING_SPLIT(@Technology, ','))
        )
        AND (@Intent = ''
        OR S.Functionality IN (SELECT
          value
        FROM STRING_SPLIT(@Intent, ','))
        )
        AND (@Team = ''
        OR CO.TEAMNAME IN (SELECT
          value
        FROM STRING_SPLIT(@Team, ','))
        )
      END

      DROP TABLE #COUNTRYID
      DROP TABLE #INDUSTRYID
    END
  END
END
