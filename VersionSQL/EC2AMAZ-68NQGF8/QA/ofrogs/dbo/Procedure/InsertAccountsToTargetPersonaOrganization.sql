/****** Object:  Procedure [dbo].[InsertAccountsToTargetPersonaOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqiq>
-- Create date: <20th May 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[InsertAccountsToTargetPersonaOrganization] 
@TargetPersonaId int,
@OrganizationId varchar(max) = ''

AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @SortOrder int = 0
  DECLARE @AccountStatus int = 1

  INSERT INTO TargetPersonaOrganization (TargetPersonaId, OrganizationId, SortOrder, AccountStatus)
    SELECT DISTINCT
      @TargetPersonaId,
      OI.value AS OrganizationId,
      @SortOrder,
      @AccountStatus
    FROM STRING_SPLIT(@OrganizationId, ',') AS OI

exec [dbo].[PopulateMarketingListFilterSummary] @TargetPersonaId

END
