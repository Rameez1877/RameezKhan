/****** Object:  Procedure [dbo].[GetJobPostLocationDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetJobPostLocationDetail] @OrganizationId int
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
