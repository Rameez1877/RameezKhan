/****** Object:  Procedure [dbo].[QA_GetTargetAccountTechnographicsResult]    Committed by VersionSQL https://www.versionsql.com ******/

-- EXEC [QA_GetCompanySearchResult] 159,0,30,'','','','',''
CREATE PROCEDURE [dbo].[QA_GetTargetAccountTechnographicsResult] 
@UserID INT,
@Page INT = 0,
@Size INT = 10,
@IndustryName varchar(500) = '',
@Name varchar(500) = '',
@CountryName varchar(500) = '',
@Revenue varchar(500) = '',
@EmployeeCount varchar(500) = ''
AS 
BEGIN
SET NOCOUNT ON;

SELECT DISTINCT O.Id,
				O.NAME [NAME],
				CO.NAME CountryName,
				I.NAME IndustryName,
				O.EmployeeCount,
				O.Revenue,
				O.WebsiteUrl,
				SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
				LEN(O.WebsiteUrl)) AS [Domain],
				CASE WHEN
	GlassDoorDescription IS NULL THEN WebSiteDescription
	ELSE GlassDoorDescription END [Description],
				SORTORDER = 
				CASE WHEN (WebsiteUrl <> '' AND Description <> '' AND EmployeeCount 
				<> 'Unknown' AND Revenue <> 'Unknown') THEN 0 
				ELSE 1 END,
				count(*) over ( partition by c.UserID ) as TotalRecords
	FROM CompanySearchResult c
	INNER JOIN Organization O on o.id = c.Id
	INNER JOIN Country CO ON CO.ID = O.CountryId
	INNER JOIN Industry I ON I.Id = O.IndustryId
	where c.userid = @userid
	and (@IndustryName = '' or i.Name = @IndustryName)
	and (@Name = '' or o.Name = @Name)
	and (@CountryName = '' or co.Name = @CountryName)
	and (@Revenue = '' or o.Revenue = @Revenue)
	and (@EmployeeCount = '' or EmployeeCount = @EmployeeCount)
	ORDER BY SORTORDER
	OFFSET (@PAGE * @SIZE) ROWS
	FETCH NEXT @SIZE ROWS ONLY



END
