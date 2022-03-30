/****** Object:  Procedure [dbo].[Public_OpportunityFinderSummaryForOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Public_OpportunityFinderSummaryForOrganization]
	@OrganizationName varchar(200) = null
AS
/*
[dbo].[Public_OpportunityFinderSummaryForOrganization] 'DigiFlight'
*/
BEGIN
	SELECT * into #Surge
    FROM 
		SurgeSummary with (nolock) 
	where
		(Organization = @OrganizationName or @OrganizationName is null)

    SELECT count(Functionality) [Count], InvestmentType
    FROM #Surge
	Group by
		InvestmentType

	SELECT sum(NoOfDecisionMaker) [Count], Functionality
    FROM #Surge
	Group by
		Functionality

	SELECT count(InvestmentType) [Count], InvestmentType
    FROM #Surge
	Group by
		InvestmentType
END
