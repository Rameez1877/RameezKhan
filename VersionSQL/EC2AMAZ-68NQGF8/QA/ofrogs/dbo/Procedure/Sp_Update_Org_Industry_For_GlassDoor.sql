/****** Object:  Procedure [dbo].[Sp_Update_Org_Industry_For_GlassDoor]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Update_Org_Industry_For_GlassDoor]
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @glassdoorindustry varchar(500),
          @IndustryID int
		Declare @q1 nvarchar(1000), @q2 nvarchar(1000)
		set @q1 = 'Disable trigger Trg_Prevent_Organization_Multiple_Update on Organization'
EXECUTE sp_executesql @q1

  DECLARE db_gd_industry CURSOR FOR
  SELECT
    glassdoorindustry,
    industry AS IndustryID
  FROM GlassDoorIndustryMap
  WHERE industry IS NOT NULL

  OPEN db_gd_industry
  FETCH NEXT FROM db_gd_industry INTO @glassdoorindustry, @IndustryID

  WHILE @@FETCH_STATUS = 0
  BEGIN
    UPDATE Organization
    SET IndustryID = @IndustryID
    WHERE industryid in (0, 46, 20, 38, 29)
    AND GlassdoorIndustry = @glassdoorindustry

    FETCH NEXT FROM db_gd_industry INTO @glassdoorindustry, @IndustryID
  END

  CLOSE db_gd_industry
  DEALLOCATE db_gd_industry

  set @q2 = 'Enable trigger Trg_Prevent_Organization_Multiple_Update on Organization'
EXECUTE sp_executesql @q2
END
