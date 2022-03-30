/****** Object:  Procedure [dbo].[GetVendorUploadedDecistionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <1 Aug 2021>
-- Description:	<Automating contact list creation>
-- =============================================
CREATE PROCEDURE [dbo].[GetVendorUploadedDecistionMakers] @WorkorderId int, @TargetPersonaId int
/*
GetVendorUploadedDecistionMakers 1805, 30273
select *from workorders where id = 348
*/
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Distinct 
        li.Id,
        li.Gender,
        li.FirstName,
        li.LastName,
        li.[Name] + ', ' + li.Designation AS [Username],
        li.[Name],
        li.Designation,
        o.[Name] AS Organization,
		o.Id as OrganizationId,
        s.EmailId,
		s.Phone,
        li.ResultantCountry AS Country,
        li.[Url],
        ml.[name] AS [Functionality],
        li.SeniorityLevel,
        s.EmailGeneratedDate,
		 i.[Name] as IndustryName
    FROM LinkedInData li WITH (NOLOCK)
        INNER JOIN dbo.McDecisionMakerList ml with (nolock)
        ON (li.Id = ml.DecisionMakerId)
        INNER JOIN SurgeContactDetail s with (nolock)
        --on (li.uniqueid = s.uniqueid and s.UserId = @UserId and s.EmailGeneratedDate > DATEADD(DAY,-15,GETDATE()))
		on (li.url = s.Url)
		INNER JOIN Organization o with (nolock)  on (o.Id = s.OrganizationId)
		  INNER JOIN TargetPersonaOrganization T with (nolock)
        ON (T.OrganizationId = o.id and T.TargetPersonaId = @TargetPersonaId)
		Left outer join Industry i on (i.Id = o.IndustryId)
       
    WHERE 
       li.WorkOrderId = @WorkorderId
END
