/****** Object:  Procedure [dbo].[GetNewHireFromDashboardSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetNewHireFromDashboardSummary]  @UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 SELECT DISTINCT
			l.Id,l.Name,l.FirstName,l.LastName,	l.OrganizationId,	o.name as Organization,trim(l.Designation) as Designation,
			l.DateOfJoining,	l.Url,	l.ResultantCountry as Country ,o.WebsiteUrl,SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],sc.EmailId,sc.Phone,'Yes' AS 'NewHire?'
	FROM	LinkedInDataNewHire l
			Inner Join McDecisionMakerListNewHire m 
			ON (l.Id = m.DecisionMakerId)
			Inner Join Organization o
			ON (o.Id = l.OrganizationId)
			INNER JOIN DASHBOARDSUMMARY DS ON DS.ID = O.ID
			Left outer join SurgeContactDetail sc on (l.uniqueId = sc.UniqueId)
	WHERE	-- o.IndustryId NOT IN (105,106,85)
			  YEAR(convert(date,l.DateOfJoining)) + 1 = YEAR(GETDATE())
			  AND MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			  AND DS.USERID = @UserID
			  ORDER BY L.DateOfJoining
			  END
			
			
			

		
