/****** Object:  Procedure [dbo].[GetPartnerTargetAccountDetailsTemp]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPartnerTargetAccountDetailsTemp] @TargetPersonaId int
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
		  @type varchar (10)
  
 
  SELECT
    @CreatedBy = CreatedBy,
	@type = type
  FROM TargetPersona
  WHERE ID = @TargetPersonaId


  SELECT
    o.id OrganizationID,
	 O.Name OrganizationName,
   	tp.id as TargetPersonaId,
	tp.Name AS TargetPersonaName,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
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
	Segment = stuff(
		(select ', ' + t2.segment
		from WebsiteNavigationSegment t2
         FOR XML PATH('')
		 ), 1, 2,''),
	--t2.segment,
	case when t3.WebsiteUrl like'%https%' then t3.WebsiteUrl else 'https://' + t3.WebsiteUrl end WebsiteUrl,
	t1.SortOrder
  FROM #Temp1 t1, WebsiteNavigationSegment t2, WebsiteOrganizationMapping t3
  where t1.OrganizationID = t3.OrganizationID
  and t3.WebsiteId = t2.Websiteid
  order by t1.SortOrder desc
 
END
