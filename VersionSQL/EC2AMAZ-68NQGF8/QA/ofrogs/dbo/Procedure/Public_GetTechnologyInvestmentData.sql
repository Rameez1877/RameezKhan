/****** Object:  Procedure [dbo].[Public_GetTechnologyInvestmentData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Public_GetTechnologyInvestmentData] 
	@OrganizationName varchar(100),
	@TechnologyKeyword varchar(100)
AS
/*
[GetTechnologyInvestmentData] null, 'BigQuery'
[GetTechnologyInvestmentData] 'Hyland-Software-Inc', null
*/
BEGIN

 SET NOCOUNT ON;
 set @OrganizationName = REPLACE(@OrganizationName, '-', ' ')

  IF @OrganizationName <> ''
    SELECT  distinct top 10
    o.name AS CompanyName,
	o.Id as OrganizationId,
	o.WebsiteUrl,
	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
    Tech.Keyword,
    tssc.StackType,
    datename(m,Tech.inserteddate)+' '+cast(datepart(yyyy,Tech.inserteddate) as varchar)  inserteddate,
    c.Name as Country,
    i.name AS Industry
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    --tag,
    Organization o,
    industry i
  WHERE
	tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
    --AND tag.id = Tech.TagIdOrganization
    --AND tag.OrganizationId = o.id
	AND tech.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND o.name LIKE @OrganizationName + '%'
	AND tech.IsAgency = 0 -- To prevent HR companies coming on front end
  else IF @TechnologyKeyword <> ''
    SELECT distinct top 10
    o.[name] AS CompanyName,
	o.Id as OrganizationId,
	o.WebsiteUrl,
	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
    Tech.Keyword,
    tssc.StackType,
    datename(m,Tech.inserteddate)+' '+cast(datepart(yyyy,Tech.inserteddate) as varchar) InsertedDate,
    c.Name as Country,
    i.name AS Industry,
	o.[Description]
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    --tag,
    Organization o,
    industry i
  WHERE --Tech.tagid = tst.TagId
      tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
    --AND tag.id = Tech.TagIdOrganization
    --AND tag.OrganizationId = o.id
	AND tech.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND Tech.Keyword in (select StackTechnologyName
    from TechStackTechnology
    where stacktechnology= @TechnologyKeyword)
	AND tech.IsAgency = 0 -- To prevent HR companies coming on front end
  END


 --select top 555 *from TechStackTechnology
