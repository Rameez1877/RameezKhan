/****** Object:  Procedure [dbo].[GetJobPostLocationDetail_V1]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[GetJobPostLocationDetail_V1] @OrganizationId int
AS
BEGIN
SELECT distinct OrganizationId ,CountryName,Location,MarketingList FROM dbo.JobPostLocationDetail with (NOLOCK) WHERE [OrganizationId] = @OrganizationId
 end 
