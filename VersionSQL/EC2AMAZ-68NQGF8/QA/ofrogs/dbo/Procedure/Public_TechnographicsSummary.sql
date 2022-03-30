/****** Object:  Procedure [dbo].[Public_TechnographicsSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Public_TechnographicsSummary]
	@Technology varchar(200)
AS
/*
	[dbo].[Public_TechnographicsSummary] 'Azure'
*/
BEGIN	
	SELECT * into #Surge
    FROM
		SurgeSummary with (nolock) 
	where
		Technology = @Technology

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
