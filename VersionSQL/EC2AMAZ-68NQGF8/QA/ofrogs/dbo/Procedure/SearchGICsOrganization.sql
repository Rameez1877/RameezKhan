/****** Object:  Procedure [dbo].[SearchGICsOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- 27-NOV-2021 - KABIR - SP will search for organizations based on filters.
-- EXEC SearchGICsOrganization 159,'','','','','','',''
CREATE PROCEDURE [dbo].[SearchGICsOrganization] 
	@UserID INT ,
    @IndustryId varchar(8000) = '',
    @CountryId varchar(8000) = '',
    @EmployeeCount varchar(8000) = '',
    @Revenue varchar(8000) = '',
    @Technology varchar(8000) = '',
    @GicCountryId varchar(8000) = '',
    @Team varchar(8000) = ''

AS
BEGIN
    SET NOCOUNT ON

	DECLARE @AppRoleID INT

  SELECT @AppRoleID = AppRoleID
    FROM AppUser
    WHERE Id = @UserId
    Declare @Limit int = IIF(@AppRoleID = 3, 200, 10000)


		;WITH CTE AS(	
	SELECT DISTINCT 
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
				C.NAME [GIC Country],
				O.WebsiteDescription
			FROM 
	GICDashboardOrganization GDO
	INNER JOIN GICDashboardTeams GDT ON GDT.OrganizationID = GDO.OrganizationID
	INNER JOIN GICDashboardTechnology GD ON GD.OrganizationID = GDT.ORGANIZATIONID
	INNER JOIN Organization O ON O.Id = GDO.OrganizationID
	INNER JOIN Country C ON C.ID = GDO.GIC_CountryID 
	INNER JOIN Industry I ON I.Id = GDO.IndustryId
	 WHERE
             (@IndustryId = ''
            OR GDO.IndustryId IN (SELECT
                value
            FROM STRING_SPLIT(@IndustryId, ',')) )

            AND (@CountryId = ''
            OR GDO.HeadquarterID IN (SELECT
                value
            FROM STRING_SPLIT(@CountryId, ',')) )

			AND (@GicCountryId = ''
            OR GDO.GIC_CountryID IN (SELECT
                value
            FROM STRING_SPLIT(@GicCountryId, ',')) )

            AND (@EmployeeCount = ''
            OR GDO.EmployeeCount IN (SELECT
                value
            FROM STRING_SPLIT(@EmployeeCount, ',')) )

            AND (@Revenue = ''
            OR GDO.Revenue IN (SELECT
                value
            FROM STRING_SPLIT(@Revenue, ',')) )

			AND (@Technology = ''
            OR GD.Technology IN (SELECT
                value
            FROM STRING_SPLIT(@Technology, ',')) )

		AND (@Team = ''
            OR GDT.TEAMNAME IN (SELECT
                value
            FROM STRING_SPLIT(@Team, ',')) ))

			SELECT DISTINCT TOP (@Limit)
			t.Id,
				t.Name OrganizationName,
				WebsiteUrl,
				[Domain],
				EmployeeCount,
				Revenue,
				IndustryID,
			 IndustryName,
				c.Name HeadquarterCountry,
				 [GIC Country],
				WebsiteDescription 
				FROM CTE T
				INNER JOIN Country C  ON C.ID = CountryId

END
