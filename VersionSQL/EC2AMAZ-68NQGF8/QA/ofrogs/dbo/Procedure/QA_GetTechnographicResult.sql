/****** Object:  Procedure [dbo].[QA_GetTechnographicResult]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[QA_GetTechnographicResult] 
@UserID INT,
@Page INT = 0,
@Size INT = 10,
@IndustryName varchar(500) = '',
@Name varchar(500) = '',
@CountryName varchar(500) = '',
@Technology VARCHAR(500) = '',
@TechnologySubCategory VARCHAR(500) = ''
AS 
BEGIN
SET NOCOUNT ON;

	
	DECLARE @IsTechnology BIT
	,@DataString VARCHAR(500)
	SELECT 
	@IsTechnology = IsTechnology, @DataString = DataString,@UserID = UserID
	FROM TechnographicsSearchResult
	WHERE USERID = @USERID

	IF @IsTechnology = 1
	BEGIN
	print '@IsTechnology = 1'
	;WITH CTE AS(
	SELECT distinct
    o.[name] AS Organization,
	o.Id as OrganizationId,
	o.WebsiteUrl,
    Tech.Keyword as Technology,
    tssc.StackType as TechnologyCategory,
	Tech.inserteddate,
    c.Name as CountryName,
    i.name AS IndustryName
	,@UserID as UserID
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    Organization o,
    industry i
  WHERE
      tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
	AND tech.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND Tech.Keyword in (select StackTechnologyName
    from TechStackTechnology
    where stacktechnology= @DataString)
	AND tech.IsAgency = 0
	AND TSSC.StackType NOT IN (
	'Azure'
	,'AWS'
	,'Google Cloud Platform (GCP)'
	,'Marketing, CRM and Automation'
	,'Netsuite'
	,'Salesforce'
	,'SAP'))
	SELECT DISTINCT Organization,OrganizationId,WebsiteUrl,Technology,TechnologyCategory,CountryName,IndustryName
	,
	SUBSTRING (WebsiteUrl, CHARINDEX( '.',WebsiteUrl) + 1,
	LEN(WebsiteUrl)) AS [Domain],
    datename(m,inserteddate)+' '+cast(datepart(yyyy,inserteddate) as varchar) 
	InsertedDate,
	count(*) over ( partition by UserID ) as TotalRecords
	FROM CTE
	WHERE 
	(@Technology = '' OR Technology IN (SELECT VALUE FROM string_split(@Technology,',')))
	AND (@TechnologySubCategory = '' OR TechnologyCategory IN (SELECT VALUE 
	FROM string_split(@TechnologySubCategory,',')))
	AND (@CountryName = '' OR CountryName IN (SELECT VALUE 
	FROM string_split(@CountryName,',')))
	AND (@IndustryName = '' OR IndustryName IN (SELECT VALUE 
	FROM string_split(@IndustryName,',')))
	AND (@Name = '' OR Organization IN (SELECT VALUE 
	FROM string_split(@Name,',')))
	ORDER BY organizationid, Domain desc
	OFFSET (@PAGE * @SIZE) ROWS
	FETCH NEXT @SIZE ROWS ONLY
	END

	ELSE IF @IsTechnology = 0
	BEGIN
	Print '@IsTechnology = 0'
	;WITH CTE AS(
	SELECT distinct
    o.name AS Organization,
	o.Id as OrganizationId,
	o.WebsiteUrl,
    Tech.Keyword as Technology,
    tssc.StackType as TechnologyCategory,
	Tech.inserteddate,
    c.Name as CountryName,
    i.name AS IndustryName,
	@UserID as UserID
  FROM Technographics Tech WITH (NOLOCK),
    TechStackTechnology tst,
    TechStackSubCategory tssc,
    Country c,
    Organization o,
    industry i
  WHERE
	tech.keyword = tst.stacktechnologyname
    AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
	AND tech.OrganizationId = o.id
    AND o.IndustryId = i.id
    AND o.name LIKE @DataString + '%'
	AND tech.IsAgency = 0 
	AND TSSC.StackType NOT IN (
	'Azure'
	,'AWS'
	,'Google Cloud Platform (GCP)'
	,'Marketing, CRM and Automation'
	,'Netsuite'
	,'Salesforce'
	,'SAP'))
	SELECT DISTINCT 
	Organization,OrganizationId,WebsiteUrl,Technology,TechnologyCategory,CountryName,IndustryName
	,
	SUBSTRING (WebsiteUrl, CHARINDEX( '.',WebsiteUrl) + 1,
	LEN(WebsiteUrl)) AS [Domain],
    datename(m,inserteddate)+' '+cast(datepart(yyyy,inserteddate) as varchar) 
	InsertedDate,
	count(*) over ( partition by UserID ) as TotalRecords
	FROM CTE
	WHERE 
	(@Technology = '' OR Technology IN (SELECT VALUE FROM string_split(@Technology,',')))
	AND (@TechnologySubCategory = '' OR TechnologyCategory IN (SELECT VALUE 
	FROM string_split(@TechnologySubCategory,',')))
	AND (@CountryName = '' OR CountryName IN (SELECT VALUE 
	FROM string_split(@CountryName,',')))
	AND (@IndustryName = '' OR IndustryName IN (SELECT VALUE 
	FROM string_split(@IndustryName,',')))
	AND (@Name = '' OR Organization IN (SELECT VALUE 
	FROM string_split(@Name,',')))
	ORDER BY organizationid, Domain desc
	OFFSET (@PAGE * @SIZE) ROWS
	FETCH NEXT @SIZE ROWS ONLY
	
	END
	END
	
