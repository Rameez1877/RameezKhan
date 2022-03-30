/****** Object:  Procedure [dbo].[QA_GetTechnologyForOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[GetTechnologyForOrganization] 2292
CREATE PROCEDURE [dbo].[QA_GetTechnologyForOrganization] 
	@OrganizationID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	select Technology, Min(SubCategoryID) as StackSubCategoryID
	into #TempTechStackTechnology
	 from Technologies where isactive=1
	 group by Technology

    SELECT  DISTINCT

      Tech.Keyword,
	  c.Name as Country,
      tssc.StackType,
	  datename(m,Tech.EarliestJobPostDate)+' '+cast(datepart(yyyy,Tech.EarliestJobPostDate) as varchar)  EarliestJobPostDate,
      datename(m,Tech.LatestJobPostDate)+' '+cast(datepart(yyyy,Tech.LatestJobPostDate) as varchar)  LatestJobPostDate
    FROM Technographics Tech WITH (NOLOCK),
    	#TempTechStackTechnology tst,
         TechStackSubCategory tssc,
         Country c,
         tag WITH (NOLOCK),
         Organization o WITH (NOLOCK),
         industry i
    WHERE tech.keyword = tst.Technology
	AND tst.StackSubCategoryId = tssc.Id
    AND c.id = Tech.CountryId
    AND tag.id = Tech.TagIdOrganization
    AND tag.OrganizationId = o.id
    AND o.IndustryId = i.id
	and o.id = @OrganizationID
	order by  4 desc

END
