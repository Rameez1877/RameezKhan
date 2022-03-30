/****** Object:  Procedure [dbo].[GetOtherProspectCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetOtherProspectCount] @UserId int
AS
BEGIN
  SET NOCOUNT ON

    DECLARE @HasCustomPersona BIT ,
		  @IsTeamGraph BIT,
		  @IsSummaryGraph BIT,
		  @IsAllGraphString VARCHAR(200),
		  @IsAllGraph BIT,
		 @TotalAccounts int


  SELECT
	@HasCustomPersona = HasCustomPersona
  FROM AppUser
  WHERE Id = @UserId

  SET @IsTeamGraph = IIF(EXISTS (SELECT * FROM DASHBOARDTEAMDATA WHERE USERID = @USERID),1,0)
  SET @IsSummaryGraph = IIF(EXISTS (SELECT * FROM DashboardDataSummary WHERE USERID = @USERID),1,0)
  
  ;WITH CTE AS( SELECT DISTINCT DATATYPE 
  FROM CustomUserData WHERE USERID = @USERID)
  SELECT @IsAllGraphString = STRING_AGG(DATATYPE,',') FROM CTE
  
  IF @IsAllGraphString LIKE '%Team%' BEGIN
  SET @IsAllGraph = IIF(@IsAllGraphString LIKE '%Intent%' OR 
  @IsAllGraphString LIKE '%Technology%'
  ,1,0)
  END
  

  DECLARE @OtherProspectAccount int = (SELECT
    OtherProspectAccount
  FROM OtherProspect
  WHERE USERID = @UserId)

  IF @OtherProspectAccount IS NOT NULL
  BEGIN
    SELECT
      @OtherProspectAccount AS TotalAccounts
  END

  --- NEW
  ELSE IF @IsTeamGraph = 1 AND @IsSummaryGraph = 0
  BEGIN 
  SELECT
      @TotalAccounts = COUNT(*)
    FROM DashboardTeamData
    WHERE UserID = @UserID

    INSERT INTO OtherProspect (OtherProspectAccount, UserID)
      VALUES (@TotalAccounts, @UserId)

    SELECT
      OTHERPROSPECTACCOUNT AS TotalAccounts
    FROM OtherProspect
    WHERE UserID = @UserID 
	END

	ELSE IF @IsSummaryGraph = 1 AND @IsTeamGraph = 0
	BEGIN
	  SELECT
      @TotalAccounts = COUNT(*)
    FROM DashboardDataSummary
    WHERE UserID = @UserID

    INSERT INTO OtherProspect (OtherProspectAccount, UserID)
      VALUES (@TotalAccounts, @UserId)

    SELECT
      OTHERPROSPECTACCOUNT AS TotalAccounts
    FROM OtherProspect
    WHERE UserID = @UserID 
	END

	ELSE IF @IsAllGraph = 1
	BEGIN
	;WITH CTE AS(
	SELECT 
	DS.OrganizationID, DS.EmployeeCount, DS.Revenue, DS.CountryName, DS.IndustryName
	, DS.Technology, DS.Functionality
	FROM DashboardDataSummary DS
	WHERE USERID = @UserId),CTE1 AS(
	SELECT DISTINCT C.*,D.DataString as Team
	FROM CTE C
	LEFT JOIN CustomUserData D ON
	C.OrganizationID = D.DataValue
	AND D.UserID = 159
	and D.DataType = 'Team'
	)
	SELECT @TotalAccounts = count(*) FROM CTE1


    INSERT INTO OtherProspect (OtherProspectAccount, UserID)
      VALUES (@TotalAccounts, @UserId)

    SELECT
      OTHERPROSPECTACCOUNT AS TotalAccounts
    FROM OtherProspect
    WHERE UserID = @UserID 

	END


---- NEW 



  ELSE 
  BEGIN
    DELETE FROM OtherProspect
    WHERE USERID = @UserId

    DECLARE @PersonaIds varchar(100),
            @RegionIds varchar(100),
            @CustomerType varchar(15),
            @IndustryGroupIds varchar(100)
            

    SELECT
      @PersonaIds = PersonaIds,
      @RegionIds = RegionIds,
      @CustomerType = CustomerType,
      @IndustryGroupIds = IndustryGroupIds
    FROM AppUser
    WHERE Id = @UserId

    SELECT
      value AS Id INTO #PersonaIds
    FROM string_split(@PersonaIds, ',')
    SELECT
      value AS Id INTO #RegionIds
    FROM string_split(@RegionIds, ',')
    SELECT
      value AS Id INTO #IndustryGroupIds
    FROM string_split(@IndustryGroupIds, ',')


    SELECT
      Id,
      [Name] INTO #Country
    FROM Country
    WHERE IsRegion IN (SELECT
      Id
    FROM #RegionIds)
    SELECT
      Id,
      Name INTO #industry
    FROM Industry
    WHERE IndustryGroupId IN (SELECT
      Id
    FROM #IndustryGroupIds)

    SELECT DISTINCT
      p.Id,
      p.[Name] AS Persona,
      a.Functionality INTO #TempPersona
    FROM persona p
    INNER JOIN adoptionframework a
      ON (p.name = a.category)
    INNER JOIN mcdecisionmaker m
      ON (m.name = a.Functionality
      AND m.isteams = 1
      AND m.isactive = 1)
      AND p.Id IN (SELECT
        Id
      FROM #PersonaIds)

    SELECT DISTINCT
      Organizationid,
      c.TeamName INTO #TempTeam
    FROM cache.OrganizationTeams c
    INNER JOIN #TempPersona tp
      ON (c.teamname = tp.functionality)
    WHERE tp.Id IN (SELECT
      Id
    FROM #PersonaIds)
    SELECT
      t.OrganizationId,
      t.keyword,
      tc.StackType INTO #TempTechnology
    FROM persona p
    INNER JOIN adoptionframeworktechnologycategory att
      ON (p.name = att.category)
    INNER JOIN TechStackTechnology tss
      ON (tss.StackSubCategoryId = att.TechnologyCategoryid)
    INNER JOIN techstacksubcategory tc
      ON (tc.id = tss.stacksubcategoryid)
    INNER JOIN Technographics t
      ON (t.keyword = tss.StackTechnologyName)
    WHERE p.Id IN (SELECT
      Id
    FROM #PersonaIds)
    SELECT DISTINCT
      s.OrganizationId,
      s.Functionality,
      s.investmenttype INTO #TempSurge
    FROM SurgeSummary s
    INNER JOIN adoptionframework a
      ON (s.functionality = a.functionality)
    INNER JOIN persona p
      ON (a.category = p.name)
      AND p.Id IN (SELECT
        Id
      FROM #PersonaIds)

    ;
    WITH CTE
    AS (SELECT DISTINCT
      o.Id,
      o.[Name],
      o.WebsiteUrl,
      o.EmployeeCount,
      o.Revenue,
      o.IndustryId,
      i.name AS [IndustryName],
      O.CountryId,
      CO.Name CountryName,
      t.keyword,
      t.StackType,
      s.Functionality,
      s.InvestmentType,
      c.TeamName,
      O.WebsiteDescription,
      @UserId AS UserID
    FROM organization o
    INNER JOIN #industry i
      ON (i.id = o.IndustryId)
    INNER JOIN #Country CO
      ON (CO.ID = O.CountryId)
    LEFT JOIN #TempTeam c
      ON (o.Id = c.OrganizationId)
    LEFT JOIN #temptechnology t
      ON (o.id = t.OrganizationId)
    LEFT JOIN #tempsurge s
      ON (o.id = s.OrganizationId)
    WHERE o.id IN (SELECT
      organizationid
    FROM #TempTeam
    UNION
    SELECT
      organizationid
    FROM #temptechnology
    UNION
    SELECT
      organizationid
    FROM #tempsurge))
   
    SELECT
      @TotalAccounts = COUNT(*)
    FROM CTE
    WHERE UserID = @UserID

    INSERT INTO OtherProspect (OtherProspectAccount, UserID)
      VALUES (@TotalAccounts, @UserId)

    SELECT
      OTHERPROSPECTACCOUNT AS TotalAccounts
    FROM OtherProspect
    WHERE UserID = @UserID

  END

END
