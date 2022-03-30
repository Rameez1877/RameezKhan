/****** Object:  Procedure [dbo].[GetOrganizationsForTargetPersonaByVendor]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[GetOrganizationsForTargetPersonaByVendor] @TargetPersonaId int
AS
-- =============================================      
-- Author:  Neeraj   
-- Create date: 23 June, 2020      
-- Updated date: 23 June, 2020      
-- Description: Gets the Target Accounts for Vendors to download.//      
-- =============================================      

BEGIN
  SET NOCOUNT ON;

  DECLARE @CreatedBy int,
        --  @DataFilter varchar(4000),
        --  @Query nvarchar(4000),
		  @type varchar (10)
  

  SELECT @CreatedBy = CreatedBy,@type = type
  FROM TargetPersona
  WHERE ID = @TargetPersonaId
 

  SELECT Distinct
    o.id OrganizationID,
	--tp.id as TargetPersonaId,
    O.Name,
	case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl--,
 --   c.name AS CountryName,
 --   i.name AS IndustryName,
 --   o.EmployeeCount,
 --   o.Revenue,
	--T.Comment,
	--tp.Name AS TargetPersonaName,
	--CONVERT(VARCHAR, tp.CreateDate, 106) as CreateDate,
	--CONVERT(VARCHAR, o.createdDate, 106) as OrganizationCreateDate
--	INTO #Temp1
  FROM Organization o,
       TargetPersonaOrganization T,
       Country c,
       Industry i,
       TargetPersona tp
  WHERE o.id = t.organizationid
  AND o.countryid = c.id
  AND o.industryid = i.id
  AND t.targetpersonaid = @TargetPersonaId
  AND t.TargetPersonaId = tp.id

 -- SELECT
 --   t1.OrganizationID,
	--t1.TargetPersonaId,
 --   t1.Name,
 --   t1.CountryName,
 --   t1.IndustryName,
 --   t1.EmployeeCount,
 --   t1.Revenue,
	--t1.WebsiteUrl,
 --   t1.TargetPersonaName,
	--t1.CreateDate,
	--t1.OrganizationCreateDate,
	--t1.Comment,
	--LS.TotalScore,
	--Case When LS.TotalScore >= 60 then 'ABM Account'
	--When  LS.TotalScore < 60 and LS.TotalScore  is not null then 'Nurturing Account'
	--Else
	--''
	--End AccountType
 -- FROM #Temp1 t1
 -- LEFT OUTER JOIN LeadScore LS
 --   ON (t1.OrganizationID = LS.OrganizationID and LS.UserId = @CreatedBy and type=@type ) 
	
END
