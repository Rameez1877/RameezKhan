/****** Object:  Procedure [dbo].[GetSurgeData_TEST]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- EXEC [GetSurgeData_TEST] 29964,159,'','','','','','','','AWS Certified,Azure'
CREATE PROCEDURE [dbo].[GetSurgeData_TEST]
   @TargetPersonaId	INT 
	--@UserId INT ,
	--@EmployeeCount		VARCHAR(500) = '',
	--@Country			VARCHAR(500) = '',
	--@Industry			VARCHAR(500) = '',
	--@Technology			VARCHAR(500) = '',
	--@TechnologyCategory VARCHAR(500) = '',
	--@Revenue			VARCHAR(500) = '',
	--@Intent				VARCHAR(500) = '',
	--@Team				VARCHAR(500) = ''		
	AS
	BEGIN
    SET NOCOUNT ON;

    declare @AppRoleId INT, @Limit INT, @PersonaTypeIds varchar(500),
	@Persona varchar(100),@Region varchar(100), 
	@UserId				int,
	@EmployeeCount		VARCHAR(500) ,
	@Country			VARCHAR(500) ,
	@Industry			VARCHAR(500) ,
	@Technology			VARCHAR(8000) ,
	@TechnologyCategory VARCHAR(8000) ,
	@Revenue			VARCHAR(500) ,
	@Intent				VARCHAR(8000) ,
	@Team				VARCHAR(8000) 

		
		SELECT @UserId = CreatedBy ,	
		   @EmployeeCount = EmployeeCounts,
		   @Country	= Locations,
		   @Industry = Industries,
		   @Technology = Technologies,
		   @TechnologyCategory = TechnologyCategory,
		   @Revenue	= Revenues,
		   @Intent = Intent,
		   @Team = Segment
		   FROM TARGETPERSONA WHERE ID = @TargetPersonaId	



    select @AppRoleId = AppRoleId,@Persona = PersonaIds,@Region = RegionIds
    from appuser
    where id=@UserId
	
	select ID INTO #COUNTRYID FROM Country WHERE IsRegion IN (SELECT VALUE FROM string_split(@REGION,','))
	
	IF @AppRoleId = 3 BEGIN
        SELECT DISTINCT top 50
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
        FROM SurgeSummary s with (nolock)
		INNER JOIN CACHE.ORGANIZATIONTEAMS CO ON CO.ORGANIZATIONID = S.ORGANIZATIONID 
		INNER JOIN AdoptionFrameworkTechnologyCategory AF ON AF.TechnologyCategory = S.TechnologyCategory
		INNER JOIN Persona P ON P.Name = AF.Category and p.Id in (
		select VALUE FROM string_split(@PERSONA,','))
		WHERE
		  (@Industry = ''
            OR S.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@Industry, ',')) )
            AND (@Country = ''
            OR S.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@Country, ',')) )
            AND (@EmployeeCount = ''
            OR S.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCount, ',')) )
            AND (@Revenue = ''
            OR S.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenue, ',')) )
			AND (@Technology = ''
            OR S.Technology IN (SELECT
                value
            FROM STRING_SPLIT(@Technology, ',')) )
			AND (@Intent = ''
            OR S.Functionality IN (SELECT
                value
            FROM STRING_SPLIT(@Intent, ',')) )
			AND (@Team = ''
           OR CO.TEAMNAME IN (SELECT
               value
          FROM STRING_SPLIT(@Team, ',')) )
		  AND S.CountryID IN (SELECT ID FROM #COUNTRYID)

		  END

		  ELSE 
		  BEGIN
		   PRINT'ELSE'
		  SELECT DISTINCT 
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
        FROM SurgeSummary s with (nolock)
		INNER JOIN CACHE.ORGANIZATIONTEAMS CO ON CO.ORGANIZATIONID = S.ORGANIZATIONID 
		INNER JOIN AdoptionFrameworkTechnologyCategory AF ON AF.TechnologyCategory = S.TechnologyCategory
		INNER JOIN Persona P ON P.Name = AF.Category and p.Id in (
		select VALUE FROM string_split(@PERSONA,','))
		WHERE
		  (@Industry = ''
            OR S.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@Industry, ',')) )
            AND (@Country = ''
            OR S.CountryId IN (SELECT
                value
            FROM STRING_SPLIT(@Country, ',')) )
            AND (@EmployeeCount = ''
            OR S.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCount, ',')) )
            AND (@Revenue = ''
            OR S.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenue, ',')) )
			AND (@Technology = ''
            OR S.Technology IN (SELECT
                value
            FROM STRING_SPLIT(@Technology, ',')) )
			AND (@Intent = ''
            OR S.Functionality IN (SELECT
                value
            FROM STRING_SPLIT(@Intent, ',')) )
			AND (@Team = ''
           OR CO.TEAMNAME IN (SELECT
               value
          FROM STRING_SPLIT(@Team, ',')) )
		  AND S.CountryID IN (SELECT ID FROM #COUNTRYID)

END
   DROP TABLE #COUNTRYID

END
