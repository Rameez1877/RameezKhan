/****** Object:  Procedure [dbo].[GetIndustries]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetIndustries] @UserId int, @IsGicSelected bit = 0
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @IndustryGroupIds varchar(100) = ''
	  SELECT
		@IndustryGroupIds = IndustryGroupIds
	  FROM AppUser WHERE Id = @UserId

	  if @IndustryGroupIds <> '' and @IsGicSelected = 0
	  begin
	    SELECT distinct
		 Id, IndustryName, IndustryGroup, nooforganizations, Name, AllOrganizations
	  FROM V_TargetPersonaFilterIndustry 
	  WHERE IndustryGroupId IN (SELECT
		value
	  FROM string_split(@IndustryGroupIds, ','))
	  order by nooforganizations desc
	  end
	  else
	  begin
	  		  SELECT distinct
		 Id, IndustryName, IndustryGroup, nooforganizations, Name, AllOrganizations
	  FROM V_TargetPersonaFilterIndustry
	  order by nooforganizations desc
		end
END
-- [dbo].[GetIndustries] 159, 0
