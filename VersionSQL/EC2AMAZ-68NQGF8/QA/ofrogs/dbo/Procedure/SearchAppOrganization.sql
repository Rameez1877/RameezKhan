/****** Object:  Procedure [dbo].[SearchAppOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SearchAppOrganization] @UserId int = 0,
@Name varchar(150) = NULL,
@CountryIds varchar(8000) = '',
@EmployeeCounts varchar(8000) = '',
@Revenues varchar(8000) = '',
@AppCategory  varchar(8000) = '',
@NoOfDownloads  varchar(8000) = ''
AS
-- =============================================      
-- Author:  Janna    
-- Create date: 24 Jul, 2019      
-- Updated date: 24 Jul, 2019     
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      
-- [dbo].[SearchAppOrganization] 1, 'JUMP Starter' 
---[dbo].[SP_Search_App_Organization] 1, 'JUMP Starter' 
BEGIN
  SET NOCOUNT ON

  CREATE TABLE #TempOrganization (
    OrganizationId int
  )
 declare @AppROleid int

  SELECT  @AppRoleid = AppROleid from APPUser
  WHERE ID= @UserId

  CREATE TABLE #DecisionMakers (
    OrganizationId int,
    DecisionMakersCount int
  )
  

  INSERT INTO #DecisionMakers (OrganizationId,
  DecisionMakersCount)
    SELECT
      o.Id OrganizationId,
      COUNT(1) AS DecisionMakersCount
    FROM linkedindata li,
        -- tag t,
         organization o
    WHERE li.organizationid = o.id
    AND (@CountryIds = ''
    OR O.CountryId IN (SELECT
      [Data]
    FROM dbo.Split(@CountryIds, ','))
    )
    GROUP BY O.Id,
             O.CountryId

Declare @Limit int = IIF(@AppRoleID = 3, 50, 50000)

     SELECT top (@Limit)
      O.Id,
      O.[Name],
      MA.AppName,
	  MAC.AppCategory  AppCategoryName,
      D.DecisionMakersCount  DecisionMakers,
	  O.WebsiteDescription  [Description],
	  MA.Installs NoOfDownloads
    FROM dbo.Organization O
	INNER JOIN MobileApp MA on MA.OrganizationID=O.Id
	INNER JOIN MobileAppCategory MAC on MA.AppCategoryID = MAC.ID
    LEFT JOIN #DecisionMakers D
      ON (O.Id = D.OrganizationId)
    WHERE  MA.AppName LIKE @Name + '%'
    AND (@CountryIds = ''
    OR O.CountryId IN (SELECT
      [Data]
    FROM dbo.Split(@CountryIds, ','))
    )
    AND (@EmployeeCounts = ''
    OR O.EmployeeCount IN (SELECT
      [Data]
    FROM dbo.Split(@EmployeeCounts, ','))
    )
    AND (@Revenues = ''
    OR O.Revenue IN (SELECT
      [Data]
    FROM dbo.Split(@Revenues, ','))
    )
	AND (@NoOfDownloads = ''
    OR MA.Installs IN (SELECT
      [Data] 
    FROM dbo.Split(@NoOfDownloads, '.'))
    )
	AND (@AppCategory = ''
    OR MA.AppCategoryID IN (SELECT
      [Data]
    FROM dbo.Split(@AppCategory, ','))
    )

  DROP TABLE #TempOrganization
  DROP TABLE #DecisionMakers
END
