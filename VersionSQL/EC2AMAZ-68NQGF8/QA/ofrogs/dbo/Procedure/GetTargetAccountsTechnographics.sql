/****** Object:  Procedure [dbo].[GetTargetAccountsTechnographics]    Committed by VersionSQL https://www.versionsql.com ******/

-- Script Date: 18-Nov-21  - Kabir
CREATE PROCEDURE [dbo].[GetTargetAccountsTechnographics] @targetpersonaid int
AS
BEGIN

  DECLARE @AppRoleId int,
          @Limit int,
          @PersonaTypeIds varchar(500),
          @Persona varchar(100),
          @Region varchar(100),
          @UserId int,
          @EmployeeCount varchar(500),
          @Country varchar(500),
          @Industry varchar(500),
          @Technology varchar(8000),
          @TechnologyCategory varchar(8000),
          @Revenue varchar(500),
          @Intent varchar(8000),
          @Team varchar(8000),
          @IndustryID varchar(500),
          @Gics varchar(500),
          @Type varchar(100),
          @NoOfDownload varchar(1000),
          @Category varchar(2000)

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
    @Gics = Gics,
    @Type = Type,
    @NoOfDownload = NoOfDownloads,
    @Category = AppCategories
  FROM TARGETPERSONA --WITH (NOLOCK)
  WHERE ID = @TargetPersonaId

  SELECT @AppRoleId = AppRoleId FROM APPUSER --WITH (NOLOCK) 
  WHERE ID = @USERID

  SET @Limit = (SELECT IIF(@AppRoleId = 3 , 200,10000))


  SELECT
    ID,
    NAME INTO #INDUSTRYID
  FROM Industry --WITH (NOLOCK)
  WHERE INDUSTRYGROUPID IN (SELECT
    VALUE
  FROM string_split(@IndustryID, ','))
  SELECT
    ID,
    NAME INTO #COUNTRYID
  FROM Country --WITH (NOLOCK)
  WHERE IsRegion IN (SELECT
    VALUE
  FROM string_split(@REGION, ','))



  IF @Type = 'App'
  BEGIN
    PRINT 'FOR APP'
	;WITH CTE AS(
    SELECT  --TOP (@Limit)
      o.id AS OrganizationId,
      o.name AS OrganizationName,
      Tech.Keyword AS Technology,
      tssc.StackType AS TechnologyCategory,
      c.name AS CountryName,
      i.name AS IndustryName,
      o.Revenue AS Revenue,
      o.EmployeeCount AS EmployeeCount,
	  O.WebsiteUrl
    FROM Technographics Tech --WITH (NOLOCK)
    INNER JOIN MobileAPP MP
      ON MP.OrganizationID = TECH.OrganizationId
    INNER JOIN Technologies tst
      ON (tech.keyword = tst.Technology)
     
    INNER JOIN TechStackSubCategory tssc
      ON (tst.SubCategory = tssc.Id)

    INNER JOIN TargetPersonaMobileAppId tpo
      ON (tpo.MobileAppId = MP.ID)
      
    INNER JOIN Organization o --WITH (NOLOCK)
      ON (O.Id = MP.OrganizationID)
     
    INNER JOIN Country C
      ON C.ID = O.CountryId

    INNER JOIN Industry I
      ON I.Id = O.IndustryId
	  WHERE 
	   (@NoOfDownload = ''
      OR MP.INSTALLS IN (SELECT
        value
      FROM STRING_SPLIT(@NoOfDownload, ','))
      )
      AND (@Category = ''
      OR MP.AppCategoryID IN (SELECT
        value
      FROM STRING_SPLIT(@Category, ','))
      )
	  AND (@Country = ''
      OR C.ID IN (SELECT
        value
      FROM STRING_SPLIT(@Country, ','))
      )
	   AND (@EmployeeCount = ''
      OR O.EmployeeCount IN (SELECT
        value
      FROM STRING_SPLIT(@EmployeeCount, ','))
      )
      AND (@Revenue = ''
      OR O.Revenue IN (SELECT
        value
      FROM STRING_SPLIT(@Revenue, ','))
      )
	   AND (@Technology = ''
      OR tst.Technology IN (SELECT
        value
      FROM STRING_SPLIT(@Technology, ','))
      )
	  AND tpo.targetpersonaid = @targetpersonaid)

	  SELECT DISTINCT TOP (@Limit) OrganizationId,
	  		 OrganizationName,
	  		 Technology,
	  		 TechnologyCategory
	  		  CountryName,
	  		  IndustryName,
	  		  Revenue,
	  		 EmployeeCount
	  ,CASE
        WHEN WebsiteUrl LIKE '%https%' THEN WebsiteUrl
        ELSE 'https://' + WebsiteUrl
      END WebsiteUrl,
      SortOrder =
                 CASE
                   WHEN IndustryName <> 'Unknown' AND
                     EmployeeCount <> 'Unknown' AND
                     Revenue <> 'Unknown' THEN 1
                   ELSE 0
                 END
				 FROM CTE
    ORDER BY SortOrder DESC
  END
  -- END FOR TYPE = APP

  ELSE
  IF @Type <> 'App'
  BEGIN -- NON-APP START

    IF @Gics <> ''
    BEGIN -- GIC CHECK
	PRINT 'FOR GIC'
	

  -- Technology
  SELECT DISTINCT
  T.OrganizationId,T.Keyword,TST.SubCategory into #Tech
  FROM TargetPersonaOrganization TPO 
  INNER JOIN Technographics T 
  ON T.OrganizationId = TPO.OrganizationId
  Inner Join Technologies TST on TST.Technology = T.Keyword
  --INNER JOIN TechStackSubCategory TSC on TSC.Id = TST.StackSubCategoryID
  WHERE TPO.TargetPersonaId = @TargetPersonaId
  AND (@Technology = ''OR T.Keyword IN (SELECT value FROM STRING_SPLIT(@Technology, ',')))
  AND TST.IsActive = 1
  AND (@TechnologyCategory = '' OR TST.SubCategory IN (SELECT value FROM 
  STRING_SPLIT(@TechnologyCategory, ',')))

   -- Teams
  SELECT DISTINCT OT.OrganizationId,OT.TeamName  into #Team
  FROM TargetPersonaOrganization TPO 
  INNER JOIN CACHE.OrganizationTeams OT
  ON OT.OrganizationId = TPO.OrganizationId 
  WHERE TPO.TargetPersonaId = @TargetPersonaId
  AND (@Team = '' OR OT.TeamName IN (SELECT VALUE FROM string_split(@Team,',')))
 

-- Gic
  SELECT DISTINCT
  G.OrganizationId,g.CountryID into #Gic
  FROM TargetPersonaOrganization TPO 
  INNER JOIN GicOrganization G
  ON G.OrganizationId = TPO.OrganizationId 
  WHERE TPO.TargetPersonaId = @TargetPersonaId
  AND G.CountryID IN (SELECT VALUE FROM string_split(@Gics,','))

    --OrganizationId,
--         OrganizationName,
--         Technology,
--         TechnologyCategory,
--        CountryName,
--         IndustryName,
--         Revenue,
--         EmployeeCount,
SELECT DISTINCT
	O.ID OrganizationId,O.NAME OrganizationName, T.Keyword Technology,T.StackType TechnologyCategory,C.name CountryName,
	I.name IndustryName,O.Revenue,O.EmployeeCount,CASE
          WHEN WebsiteUrl LIKE '%https%' THEN WebsiteUrl
          ELSE 'https://' + WebsiteUrl
        END WebsiteUrl,
        SortOrder =
                   CASE
                     WHEN I.name <> 'Unknown' AND
                       EmployeeCount <> 'Unknown' AND
                       Revenue <> 'Unknown' THEN 1
                     ELSE 0
                   END

	FROM Organization O
	INNER JOIN #Tech T ON T.OrganizationID = O.ID
	INNER JOIN #Team Te on Te.OrganizationId = O.ID
	INNER JOIN #Gic G on G.OrganizationID = O.ID
	INNER JOIN Country C on C.id = O.CountryID
	INNER JOIN Industry I on I.ID = O.IndustryID
 

    END
    -- GIC END


    IF @Gics = ''  
    BEGIN -- NON-GIC START
      IF @Persona IS NULL OR @Persona = ''
      BEGIN
	  PRINT 'Gics =  and persona is null'
        SELECT DISTINCT TOP (@Limit)
          o.id AS OrganizationId,
          o.name AS OrganizationName,
          Tech.Keyword AS Technology,
          tssc.StackType AS TechnologyCategory,
          c.name AS CountryName,
          i.name AS IndustryName,
          o.Revenue AS Revenue,
          o.EmployeeCount AS EmployeeCount,
          CASE
            WHEN O.WebsiteUrl LIKE '%https%' THEN O.WebsiteUrl
            ELSE 'https://' + O.WebsiteUrl
          END WebsiteUrl,
          SortOrder =
                     CASE
                       WHEN i.Name <> 'Unknown' AND
                         o.EmployeeCount <> 'Unknown' AND
                         o.Revenue <> 'Unknown' THEN 1
                       ELSE 0
                     END
        FROM Technographics Tech --WITH (NOLOCK)
        INNER JOIN Technologies tst
          ON (tech.keyword = tst.Technology
          AND (@Technology = ''
          OR tst.Technology IN (SELECT
            value
          FROM STRING_SPLIT(@Technology, ','))
          ))
        INNER JOIN TechStackSubCategory tssc
          ON (tst.SubCategoryID = tssc.Id
          AND (@TechnologyCategory = ''
          OR tssc.stacktype IN (SELECT
            value
          FROM STRING_SPLIT(@TechnologyCategory, ','))
          ))
        INNER JOIN TargetPersonaorganization tpo
          ON (tpo.OrganizationId = Tech.OrganizationId
          AND tpo.targetpersonaid = @targetpersonaid)
        INNER JOIN Organization o --WITH (NOLOCK)
          ON (tpo.OrganizationId = o.id
          AND (@EmployeeCount = ''
          OR O.EmployeeCount IN (SELECT
            value
          FROM STRING_SPLIT(@EmployeeCount, ','))
          )
          AND (@Revenue = ''
          OR O.Revenue IN (SELECT
            value
          FROM STRING_SPLIT(@Revenue, ','))
          ))
        INNER JOIN #COUNTRYID C
          ON C.ID = O.CountryId
          AND (@Country = ''
          OR C.ID IN (SELECT
            value
          FROM STRING_SPLIT(@Country, ','))
          )
        INNER JOIN #INDUSTRYID I
          ON I.Id = O.IndustryId
          AND (@Industry = ''
          OR I.Id IN (SELECT
            value
          FROM STRING_SPLIT(@Industry, ','))
          )
        ORDER BY SortOrder DESC

      END
      ELSE 

      BEGIN
	  	  PRINT 'Gics =  and persona is NOT null'

        SELECT DISTINCT TOP (@Limit)
          o.id AS OrganizationId,
          o.name AS OrganizationName,
          Tech.Keyword AS Technology,
          tssc.StackType AS TechnologyCategory,
          c.name AS CountryName,
          i.name AS IndustryName,
          o.Revenue AS Revenue,
          o.EmployeeCount AS EmployeeCount,
          CASE
            WHEN O.WebsiteUrl LIKE '%https%' THEN O.WebsiteUrl
            ELSE 'https://' + O.WebsiteUrl
          END WebsiteUrl,
          SortOrder =
                     CASE
                       WHEN i.Name <> 'Unknown' AND
                         o.EmployeeCount <> 'Unknown' AND
                         o.Revenue <> 'Unknown' THEN 1
                       ELSE 0
                     END
        FROM Technographics Tech --WITH (NOLOCK)
        INNER JOIN Technologies tst
          ON (tech.keyword = tst.Technology
          AND (@Technology = ''
          OR TST.Technology IN (SELECT
            value
          FROM STRING_SPLIT(@Technology, ','))
          )
          )
        INNER JOIN TechStackSubCategory tssc
          ON (tst.SubCategoryID = tssc.Id
          AND (@TechnologyCategory = ''
          OR TSSC.StackType IN (SELECT
            value
          FROM STRING_SPLIT(@TechnologyCategory, ','))
          )
          )
        INNER JOIN TargetPersonaorganization tpo
          ON (tpo.OrganizationId = Tech.OrganizationId
          AND tpo.targetpersonaid = @targetpersonaid)
        INNER JOIN Organization o --WITH (NOLOCK)
          ON (tpo.OrganizationId = o.id)
        INNER JOIN #COUNTRYID C
          ON C.ID = O.COUNTRYID
          AND (@Country = ''
          OR O.CountryId IN (SELECT
            value
          FROM STRING_SPLIT(@Country, ','))
          )
        INNER JOIN #INDUSTRYID I
          ON I.ID = O.INDUSTRYID
          AND (@Industry = ''
          OR O.IndustryId IN (SELECT
            value
          FROM STRING_SPLIT(@Industry, ','))
          )
        INNER JOIN AdoptionFrameworkTechnologyCategory AF
          ON AF.TECHNOLOGYCATEGORY = TSSC.StackType
        INNER JOIN Persona P
          ON (P.NAME = AF.CATEGORY
          AND P.ID IN (SELECT
            VALUE
          FROM string_split(@PERSONA, ','))
          )
        WHERE (@EmployeeCount = ''
        OR O.EmployeeCount IN (SELECT
          value
        FROM STRING_SPLIT(@EmployeeCount, ','))
        )
        AND (@Revenue = ''
        OR O.Revenue IN (SELECT
          value
        FROM STRING_SPLIT(@Revenue, ','))
        )

        ORDER BY SortOrder DESC
      END
    END


  END

END
