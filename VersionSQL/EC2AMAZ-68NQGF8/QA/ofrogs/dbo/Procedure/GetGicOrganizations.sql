/****** Object:  Procedure [dbo].[GetGicOrganizations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetGicOrganizations
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SET NOCOUNT ON;

  SELECT DISTINCT
			O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            O.WebsiteUrl,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
            c.[Name] as CountryName,
            i.[name] as IndustryName,
            o.Revenue,
            o.EmployeeCount
    FROM GicOrganization gic
        inner join organization o WITH (NOLOCK) on (gic.OrganizationId = o.id)
		inner join country c on (c.ID = gic.CountryID)
		inner join Industry i on (i.Id = o.IndustryId)
 
END
