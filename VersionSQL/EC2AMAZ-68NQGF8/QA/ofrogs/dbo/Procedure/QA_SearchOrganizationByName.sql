/****** Object:  Procedure [dbo].[QA_SearchOrganizationByName]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[QA_SearchOrganizationByName]
    @Name varchar(150) = NULL
AS

BEGIN
    SET NOCOUNT ON

        SELECT TOP (2000)
            O.Id,
            O.[Name],
            case when len(o.WebsiteDescription) < 3 or o.WebsiteDescription IS NULL or o.WebsiteDescription = '' then o.glassdoordescription else o.WebsiteDescription end AS [Description],
            case when isnull(O.WebsiteUrl, '') = '' then '' when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
            c.name as [CountryName],
            i.name as [IndustryName],
            o.Revenue,
            o.EmployeeCount,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain]
        FROM dbo.Organization O WITH (NOLOCK)
            INNER JOIN Country C on (c.id = o.countryid)
            INNER JOIN Industry i on (i.id = o.Industryid)
        WHERE o.Name LIKE @Name + '%'
		order by len(O.[Name]) asc, o.Name

END
