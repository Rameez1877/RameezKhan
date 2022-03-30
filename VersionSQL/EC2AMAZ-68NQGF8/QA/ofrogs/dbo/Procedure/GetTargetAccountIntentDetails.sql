/****** Object:  Procedure [dbo].[GetTargetAccountIntentDetails]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[GetTargetAccountIntentDetails]
@TargetPersonaId int
AS
BEGIN
 Declare @UserId int

 Select @UserId = CreatedBy From TargetPersona where id = @targetPersonaId

SELECT Distinct
  Organization,
  OrganizationId,
  Industry,
  Functionality,
  Technology,
  TechnologyCategory,
  InvestmentType,
  CountryName into #tempsurgesummary
FROM SurgeSummary with (nolock)
WHERE CountryName IN (Select Name from UserTargetCountry U, Country C WHERE UserId = @UserId and u.countryid=c.id )
AND Functionality IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )
AND Technology IN (Select technology from UserTargetTechnology WHERE UserId = @UserId union select 'NA' )
 
 
 SELECT Distinct
    o.id OrganizationID,
	tp.name as TargetPersonaName,
    O.Name,
	case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
	T.Comment,
	S.Functionality,
	S.Technology,
	S.TechnologyCategory,
	S.InvestmentType
	--tp.Name AS TargetPersonaName,
	--CONVERT(VARCHAR, tp.CreateDate, 106) as CreateDate,
	--CONVERT(VARCHAR, o.createdDate, 106) as OrganizationCreateDate
    FROM TargetPersonaOrganization T 
    inner join organization o
    on (t.organizationid = o.id)
    left outer join #tempsurgesummary S
    on (t.organizationId = s.organizationId)
    inner join Country c
    on (o.CountryId = c.ID)
    inner join Industry i
    on (o.IndustryId = i.id)
    inner join Targetpersona tp
    on (tp.id = t.TargetPersonaId  and T.TargetPersonaId = @TargetPersonaId) 
END 
