/****** Object:  Procedure [dbo].[SP_GetDecisionMakersForGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDecisionMakersForGraph]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
      v.FunctionalityDisplay AS [Functionality],
      count(*) As NoOfDecisionMakers
    FROM dbo.LinkedInData li WITH (NOLOCK)
    INNER JOIN dbo.McDecisionMakerList ml
      ON (li.Id = ml.DecisionMakerId)
    INNER JOIN dbo.V_Functionality v
      ON (v.Functionality = ml.[Name])
    INNER JOIN dbo.Tag T
      ON (T.Id = li.TagId
      AND T.TagTypeId = 1)
    INNER JOIN dbo.Organization o
      ON (o.id = t.organizationid)
       WHERE ml.mode = 'Keyword Based List'
    AND li.[Url] <> ''
    AND T.OrganizationId IN (SELECT
      OrganizationId
    FROM TargetPersonaOrganization
    WHERE TargetPersonaId = @TargetPersonaId)
    AND RTRIM(li.ResultantCountry) <> ''
	group by v.FunctionalityDisplay
	order by NoOfDecisionMakers desc
END
