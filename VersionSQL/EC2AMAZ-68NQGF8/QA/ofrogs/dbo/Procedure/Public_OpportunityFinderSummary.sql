/****** Object:  Procedure [dbo].[Public_OpportunityFinderSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Public_OpportunityFinderSummary]
	@Opportunity varchar(200) = null
AS
/*
[dbo].[Public_OpportunityFinderSummary] 'Retail'
*/
BEGIN
	SELECT * into #Surge
    FROM 
		SurgeSummary with (nolock) 
	where
		(Functionality = @Opportunity or @Opportunity is null)

    SELECT count(Organization) [Count], Revenue
    FROM #Surge
	Group by
		Revenue

	SELECT count(Organization) [Count], Industry
    FROM #Surge
	Group by
		Industry

	SELECT count(Organization) [Count], EmployeeCount
    FROM #Surge
	Group by
		EmployeeCount
		
	SELECT count(Organization) [Count], CountryName
    FROM #Surge
	Group by
		CountryName
END
