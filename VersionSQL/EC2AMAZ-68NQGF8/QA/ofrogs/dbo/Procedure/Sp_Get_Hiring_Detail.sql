/****** Object:  Procedure [dbo].[Sp_Get_Hiring_Detail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	Janna
-- Create date: 27/06/2019
-- Description:	TargetPersona Screen Popup For Hiring Details For A Organization
-- Filter records based on what is configured for Lead Score
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Get_Hiring_Detail] @OrganizationID int,
@UserID int
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
 
  DECLARE @Query nvarchar(4000), @Name varchar(4000)
  select @Name =  name from organization
  where id = @OrganizationID
SELECT
 -- o.name AS CompanyName,
  DISTINCT
  @Name as CompanyName,
  JPAE.ExcellenceArea AS FocusArea,
  --ind.url,
  ind.JobTitle,
  ind.location AS Location,
  ind.Summary,
  ind.SeniorityLevel
FROM IndeedJobPostLast6Months ind with (NOLOCK),
   --  Tag t with (NOLOCK),
   --  Organization O with (NOLOCK),
     JobPostExcellenceArea JPAE with (NOLOCK)
WHERE JPAE.JobPostID = ind.ID
--AND Ind.TagIdOrganization = T.ID
--AND T.OrganizationID = O.id
--AND t.OrganizationID = @OrganizationID
AND ind.OrganizationID = @OrganizationID
AND JPAE.ExcellenceArea IN (select Functionality from UserTargetFunctionality where UserID = @UserID)
and Ind.countrycode IN
(select c.id from country c, UserTargetCountry UC
where uc.CountryID = c.id
and uc.UserID =@UserID) 
--AND ind.jobdate >= getdate() - 180
END
--exec [Sp_Get_Hiring_Detail] 40125, 300
