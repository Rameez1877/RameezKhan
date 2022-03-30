/****** Object:  Procedure [dbo].[sp_insert_GD_in_organization_by_company]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_GD_in_organization_by_company]
-- Add the parameters for the stored procedure here

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  -- Insert statements for procedure here


  DECLARE @gdid int,
          @gdcompany varchar(500),
          @GdWebsite varchar(500),
          @GdCountryID int,
          @GDGlassDoorIndustry varchar(500),
          @GdWebsiteTitle varchar(7000),
          @GdWebsiteDescription varchar(7000),
          @GdWebsiteKeywords varchar(7000),
          @GdRevenue varchar(100),
          @GDEmployeeCount varchar(100),
		  @GDGlassdoorDescription varchar(7000)
  DECLARE db_gd_org CURSOR FOR

  SELECT --top 1000
    id,
    ltrim(company) company,
    case when WebsiteMatchScore = 5 then Website
   else
   NUll
   end 
    Website
	,
    CountryID,
    GlassDoorIndustry,
    Title,
    Description,
    Keyword,
    Revenue,
    EmployeeCount,GlassdoorDescription
  FROM GlassdoorOrganization gd
  WHERE InputType='CompanyName'
  and  Purpose='Pulled data for Technographics and Award Organizations on 13 JUne 2019'
  and GlassdoorUrl <> 'nan'
  and not exists
  (select * from organization o
  where o.name collate SQL_Latin1_General_CP1_CI_AS = ltrim(gd.company))
  

  OPEN db_gd_org
  FETCH NEXT FROM db_gd_org INTO @gdid, @gdcompany, @GdWebsite, @GdCountryID, @GDGlassDoorIndustry, @GdWebsiteTitle, @GdWebsiteDescription, @GdWebsiteKeywords, @GdRevenue, @GDEmployeeCount, @GDGlassdoorDescription

  WHILE @@FETCH_STATUS = 0
  BEGIN
  

  
    FETCH NEXT FROM db_gd_org INTO @gdid, @gdcompany, @GdWebsite, @GdCountryID, @GDGlassDoorIndustry,
	 @GdWebsiteTitle, @GdWebsiteDescription, @GdWebsiteKeywords, @GdRevenue, @GDEmployeeCount,@GDGlassdoorDescription
	 If @GdCountryID is null 
	 set @GdCountryID =0

    EXEC [dbo].[SaveOrganization] @name2 = @gdcompany,
                              @Name = @gdcompany,
                              @FullName = @gdcompany,
                              @WebsiteUrl = @GdWebsite,
                              @Category = 'Major',
                              @SubIndustryId = 0,
                              @IndustryId = 0,
                              @RegionId = 0,
                              @CountryId = @GdCountryID,
                              @DataSource = 'GlassDoorByCompanyName',
                              @GlassDoorIndustry = @GDGlassDoorIndustry,
                              @WebsiteTitle = @GdWebsiteTitle,
                              @WebsiteDescription =@GdWebsiteDescription,
                              @WebsiteKeywords =@GdWebsiteKeywords,
                              @Revenue = @GdRevenue,
                              @EmployeeCount =  @GDEmployeeCount,
							  @GlassdoorDescription = @GDGlassdoorDescription
    
	UPDATE glassdoororganization
    SET isprocessed = 'Y'
    WHERE id = @gdid

  END

  CLOSE db_gd_org
  DEALLOCATE db_gd_org
END
