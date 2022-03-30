/****** Object:  Procedure [dbo].[MyCustomerGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE MyCustomerGraph
	-- Add the parameters for the stored procedure here
	@orgIds varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 CREATE TABLE #TempOrganization (
    OrganizationId int,
    CountryID int
  )

   INSERT INTO #TempOrganization (OrganizationId,
    CountryID)
      SELECT DISTINCT
        o.Id OrganizationId,
        o.countryid
      FROM linkedindata li WITH (NOLOCK),
           tag t WITH (NOLOCK),
           organization o WITH (NOLOCK),
           McDecisionmakerlist mc WITH (NOLOCK)
      WHERE li.tagid = t.id
      AND t.organizationid = o.id
  
      AND O.[id] IN (SELECT
        [Data]
      FROM dbo.Split(@orgIds, ','))
      

END
