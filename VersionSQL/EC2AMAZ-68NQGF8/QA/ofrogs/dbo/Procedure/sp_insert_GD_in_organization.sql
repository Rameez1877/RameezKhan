/****** Object:  Procedure [dbo].[sp_insert_GD_in_organization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insert_GD_in_organization]
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

  SELECT 
    id,
    ltrim(company),
    Website,
    CountryID,
    GlassDoorIndustry,
    Title,
    Description,
    Keyword,
    Revenue,
    EmployeeCount,GlassdoorDescription
  FROM GlassdoorOrganization
  WHERE IsProcessed = 'N' AND CountryId is not null
  --AND IsWebDataPulled = 'Y' 
  and InputType='Keyword'

and ltrim(company) collate Latin1_General_CI_AI not in (select Name from Organization)

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
                              @DataSource = 'GlassDoor',
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
