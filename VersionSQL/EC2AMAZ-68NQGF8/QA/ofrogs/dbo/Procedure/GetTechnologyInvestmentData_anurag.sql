/****** Object:  Procedure [dbo].[GetTechnologyInvestmentData_anurag]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologyInvestmentData_anurag]
  @OrganizationName varchar(100),
  @TechnologyKeyword varchar(100)
AS
/*
 [dbo].[GetTechnologyInvestmentData_anurag] '', 'AWS'
*/
BEGIN

  SET NOCOUNT ON;
  IF @OrganizationName <> ''
    SELECT distinct
    o.name AS CompanyName,
    Tech.Keyword,
    tssc.StackType,
    datename(m,Tech.inserteddate)+' '+cast(datepart(yyyy,Tech.inserteddate) as varchar)  inserteddate,
    c.Name as Country,
    i.name AS Industry
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    tag,
    Organization o,
    industry i
  WHERE
	tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
    AND tag.id = Tech.TagIdOrganization
    AND tag.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND o.name LIKE @OrganizationName + '%'
  else IF @TechnologyKeyword <> ''
    SELECT distinct
    o.[name] AS CompanyName,
    Tech.Keyword,
    tssc.StackType,
    datename(m,Tech.inserteddate)+' '+cast(datepart(yyyy,Tech.inserteddate) as varchar) InsertedDate,
    c.Name as Country,
    i.name AS Industry
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    tag,
    Organization o,
    industry i
  WHERE --Tech.tagid = tst.TagId
      tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
    AND tag.id = Tech.TagIdOrganization
    AND tag.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND Tech.Keyword in (select StackTechnologyName
    from TechStackTechnology
    where stacktechnology= @TechnologyKeyword)
END
