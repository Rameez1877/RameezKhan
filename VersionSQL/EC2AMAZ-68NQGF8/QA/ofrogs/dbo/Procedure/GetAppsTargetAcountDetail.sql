/****** Object:  Procedure [dbo].[GetAppsTargetAcountDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAppsTargetAcountDetail] @TargetPersonaId int
AS
-- =============================================      
-- Author:  Asef Daqiq    
-- Create date: 22 Jun, 2021      
-- Description:       
-- =============================================      
-- [dbo].[GetAppsTargetAcountDetail] 29499
BEGIN
  SET NOCOUNT ON
	 Declare @PersonaName varchar(200) = '',
			 @MarketingListId int
		
	 Select @PersonaName = [Name] from TargetPersona where Id = @TargetPersonaId
	 Select @MarketingListId = Id from MarketingLists where TargetPersonaId = @TargetPersonaId

     SELECT 
      O.Id as OrganizationId,
      O.[Name] as OrganizationName,
	  O.Revenue,
	  O.EmployeeCount,
	  O.WebsiteUrl,
	  SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
      MA.AppName,
	  MAC.AppCategory as AppCategoryName,
	  cast(MA.Rating as decimal(10,1)) as Rating,
	  MA.AppUrl,
	  MA.Installs NoOfDownloads,
	  Ma.Id as MobileAppId,
	  @PersonaName as TargetPersonaName,
	  @MarketingListId as MarketingListId
	FROM MobileApp MA 
	Inner join TargetPersonaMobileAppId TPM on (TPM.MobileAppId = MA.Id and TPM.TargetPersonaId = @TargetPersonaId)
	Inner join dbo.Organization O on (MA.OrganizationID=O.Id)
	INNER JOIN MobileAppCategory MAC on MA.AppCategoryID = MAC.ID
END
