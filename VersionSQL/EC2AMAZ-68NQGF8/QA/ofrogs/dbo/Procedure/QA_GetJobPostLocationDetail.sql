/****** Object:  Procedure [dbo].[QA_GetJobPostLocationDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetJobPostLocationDetail] @OrganizationId int
AS
BEGIN
	SET NOCOUNT ON;


SELECT distinct OrganizationId 
     ,CountryName
      ,Location
      ,MarketingList
  FROM dbo.JobPostLocationDetail with (NOLOCK)
 WHERE [OrganizationId] = @OrganizationId

 end 
