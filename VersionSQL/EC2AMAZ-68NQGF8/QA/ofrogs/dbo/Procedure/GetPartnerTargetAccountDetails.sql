/****** Object:  Procedure [dbo].[GetPartnerTargetAccountDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPartnerTargetAccountDetails] @TargetPersonaId int
/*
exec  [dbo].[GetPartnerTargetAccountDetails] 18837

*/
AS
-- =============================================      
-- Author:    
-- Create date:     
-- Updated date:   
-- Description: Gets the Target Accounts for Target Accounts Details page.//      
-- =============================================      

BEGIN
  SET NOCOUNT ON;

  DECLARE @CreatedBy int,
         @Query nvarchar(4000),
		  @type varchar (10),
		  @MarketingListId int
  
 
  SELECT
    @CreatedBy = CreatedBy,
	@type = type
  FROM TargetPersona
  WHERE ID = @TargetPersonaId

  SELECT
    @MarketingListId = id
  FROM MarketingLists
  WHERE TargetPersonaId = @TargetPersonaId

  SELECT
    o.id OrganizationID,
	 O.Name OrganizationName,
   	tp.id as TargetPersonaId,
	tp.Name AS TargetPersonaName,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
	o.websiteDescription as [Description],
	T.SortOrder
	INTO #Temp1
  FROM organization o,
       TargetPersonaOrganization T,
       country c,
       industry i,
       TargetPersona tp
  WHERE o.id = t.organizationid
  AND o.countryid = c.id
  AND o.industryid = i.id
  AND t.targetpersonaid = @TargetPersonaId
  AND t.TargetPersonaId = tp.id
   SELECT distinct 
    t1.OrganizationID,
	t1.TargetPersonaId,
    t1.OrganizationName,
    t1.CountryName,
    t1.IndustryName,
    t1.EmployeeCount,
    t1.Revenue,
    t1.TargetPersonaName,
	t2.product,
	t2.solution,
	REPLACE
    (REPLACE
    (STUFF
    ((SELECT
        ', ' + Keyword
    FROM (SELECT DISTINCT
        Keyword
    FROM WebsiteNavigationSegment t2
    WHERE t3.WebsiteId = t2.Websiteid) wns
    FOR xml PATH ('')), 1, 1, ''), '&amp;', '&'), '''', '')
	AS Tag,
	--t2.segment,
	case when t3.WebsiteUrl like'%https%' then t3.WebsiteUrl else 'https://' + t3.WebsiteUrl end WebsiteUrl,
	t1.SortOrder,
	t1.[Description],
	@MarketingListId as MarketingListId
  --FROM #Temp1 t1, WebsiteNavigationSegment t2, WebsiteOrganizationMapping t3
  --where t1.OrganizationID = t3.OrganizationID
  --and t3.WebsiteId = t2.Websiteid
  --order by t1.SortOrder desc

  from #Temp1 t1
  left outer join WebsiteOrganizationMapping t3
  on (t1.OrganizationID = t3.OrganizationId)
  left outer join WebsiteNavigationSegment t2
  on (t3.WebsiteId = t2.Websiteid)
  order by t1.SortOrder desc
 
END
