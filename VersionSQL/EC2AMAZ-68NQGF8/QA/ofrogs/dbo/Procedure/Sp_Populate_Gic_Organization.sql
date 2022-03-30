/****** Object:  Procedure [dbo].[Sp_Populate_Gic_Organization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	Janna
-- Create date: 20,Jun,2019
-- Description:	Populate GIC Country and Organizations, Run based on need
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Populate_Gic_Organization]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  declare @cmd nvarchar(250)
  SET NOCOUNT ON;
  set @cmd  = 'disable trigger GICOrganization_Prevent_delete on  GicOrganization'
  EXEC sys.sp_executesql @cmd;
  DELETE GicOrganization
   set @cmd  = 'enable trigger GICOrganization_Prevent_delete on  GicOrganization'
   EXEC sys.sp_executesql @cmd;
  INSERT INTO GicOrganization
    SELECT

    DISTINCT
      country_gic.ID CountryID,
      O.id OrganizationID
    FROM linkedindata li,
         tag t,
         organization o,
         country c,
         country country_gic
    WHERE li.tagid = t.id
    AND t.OrganizationId = o.id
    AND o.countryid = c.id
    AND o.revenue IN ('100M-250M', '250M-500M', '500M-1B', '>1B')
    AND LEN(url) > 5
	AND country_gic.ID in ('38','13','25')
    AND CHARINDEX(c.name, CASE
      WHEN
        li.ResultantCountry LIKE 'United States%' THEN 'United States of America'
      ELSE li.ResultantCountry
    END) = 0
    AND country_gic.Name =
                          CASE
                            WHEN
                              li.ResultantCountry LIKE 'United States%' THEN 'United States of America'
                            ELSE li.ResultantCountry
                          END


END
