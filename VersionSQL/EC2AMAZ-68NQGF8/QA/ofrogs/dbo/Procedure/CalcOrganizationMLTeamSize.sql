/****** Object:  Procedure [dbo].[CalcOrganizationMLTeamSize]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Organization_Team_Strength]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT
  o.name Organization,
  replace(mc.name,'OF ','') MarketingList,
  COUNT(*) TeamSize
FROM McdecisionMakerList MC,
     LinkedinData Li WITH (NOLOCK),
     Tag T,
     Organization O
WHERE mc.Mode = 'Keyword Based List'
AND mc.decisionmakerid = li.id
AND li.tagid = t.id
AND t.organizationid = o.id
AND url <> ''
and mc.name <> 'Others'
GROUP BY o.id,
         o.name,
         mc.name
order 
		 by o.name,
         mc.name
END
