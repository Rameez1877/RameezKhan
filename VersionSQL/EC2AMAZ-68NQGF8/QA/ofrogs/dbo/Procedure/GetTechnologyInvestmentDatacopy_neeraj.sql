/****** Object:  Procedure [dbo].[GetTechnologyInvestmentDatacopy_neeraj]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTechnologyInvestmentDatacopy_neeraj] 
@OrganizationName varchar(100),
@TechnologyKeyword varchar(100),
@UserId int
AS
BEGIN

SET NOCOUNT ON;

DECLARE @AppRoleID int

 SELECT @AppRoleID = AppRoleID
    FROM AppUser
    WHERE Id = @UserId
    Declare @Limit int = IIF(@AppRoleID = 3, 100, 999999)

Create table #temptechnographics
(
	CompanyName varchar(1000),
	Keyword varchar(1000),
	Stacktype varchar(1000),
	InsertedDate varchar(100),
	Country varchar(1000),
	Industry varchar(1000),
	Description varchar(4000)
)

  IF @OrganizationName <> ''
  BEGIN

	INSERT into #temptechnographics (CompanyName,Keyword,Stacktype,InsertedDate,Country,Industry)
    SELECT DISTINCT TOP (@Limit)
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

	Select CompanyName,Keyword,Stacktype,InsertedDate,Country,Industry from #temptechnographics
END

  else IF @TechnologyKeyword <> ''

  BEGIN

	INSERT into #temptechnographics (CompanyName,Keyword,Stacktype,InsertedDate,Country,Industry,Description)
    SELECT DISTINCT TOP (@Limit)
    o.[name] AS CompanyName,
    Tech.Keyword,
    tssc.StackType,
    datename(m,Tech.inserteddate)+' '+cast(datepart(yyyy,Tech.inserteddate) as varchar) InsertedDate,
    c.Name as Country,
    i.name AS Industry,
	tst.description
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

	Select CompanyName,Keyword,Stacktype,InsertedDate,Country,Industry,Description from #temptechnographics

	END
END
