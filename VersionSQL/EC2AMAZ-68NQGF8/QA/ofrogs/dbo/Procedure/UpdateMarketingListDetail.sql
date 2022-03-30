/****** Object:  Procedure [dbo].[UpdateMarketingListDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateMarketingListDetail

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT 
					MArketinglistid,
					count(distinct LinkedInUrl) as NumberofDecisionMakers,
					count(distinct OrganizationId) as NumberofAccounts
					into #tempProfile
			FROM	DecisionMakersForMarketingList
			GROUP BY 
					marketinglistId

					update m
					set m.totalDecisionMakers = t.NumberofDecisionMakers, m.TotalAccounts = t.NumberofAccounts
					from marketinglists m
					inner join #tempProfile t  on (t.MArketinglistid = m.id)
END
