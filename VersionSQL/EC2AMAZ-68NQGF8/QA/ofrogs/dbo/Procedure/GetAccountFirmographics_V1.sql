/****** Object:  Procedure [dbo].[GetAccountFirmographics_V1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAccountFirmographics_V1]
@UserId INT,
@OrganizationID INT
AS
/*
[dbo].[GetAccountFirmographics] 1, 210665
*/
BEGIN


  SET NOCOUNT ON;
  DECLARE @GICCountryList varchar(1000)

	SELECT
    @GICCountryList = STRING_AGG(c.name, ',') 
	FROM GICOrganization GIC,
         Country C
    WHERE GIC.OrganizationID =  @OrganizationID
    AND GIC.CountryID = C.id

  SELECT
	o.Name as OrganizationName,
    o.Revenue,
	c.Name as Headquarter,
	REPLACE((SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl))), '/', '') AS [Domain],
    i.name AS IndustryName,
    o.EmployeeCount,
    @GICCountryList GICCountryList,
	case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.GlassdoorDescription else o.websitedescription end [Description],
	case when O.WebsiteUrl like'http%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteURL
  FROM Organization o with (nolock)
  INNER JOIN Industry i  ON (i.Id = o.IndustryId)
  INNER Join Country c on (o.CountryId = c.ID)
 AND O.ID = @OrganizationID
END
