/****** Object:  Procedure [dbo].[GetCountries]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCountries] @UserId int, @IsGicSelected bit = 0
AS
BEGIN

  SET NOCOUNT ON;

	  DECLARE @RegionIds varchar(100) = '', @hasRegionId BIT
	  SELECT
		@RegionIds = RegionIds
	  FROM AppUser WHERE Id = @UserId

	 SET @hasRegionId = IIF(@RegionIds IS NULL or @RegionIds = '',0,1)

	  SELECT
		Id,
		countryname,
		nooforganizations,
		Name,
		AllOrganizations,
		code
	  FROM V_TargetPersonaFilterCountry
	  WHERE 
	  (@hasRegionId = 0 or @IsGicSelected = 1 or
	  RegionId IN (SELECT
		value
	  FROM string_split(@RegionIds, ',')) )
	  ORDER BY nooforganizations DESC
	
END


--[dbo].[GetCountries] 159, 0
