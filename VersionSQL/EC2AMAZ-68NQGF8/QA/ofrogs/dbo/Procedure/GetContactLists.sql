/****** Object:  Procedure [dbo].[GetContactLists]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContactLists]
	@UserId int,
	@Page INT = 0,
	@Size INT = 10,
	@Name VARCHAR(500) = ''
AS
/*
[dbo].[GetContactLists] 78, 0, 20, ''
'L&D People Intelligence 10'
*/
BEGIN
  SET NOCOUNT ON;

  SELECT
    ml.Id,
    ml.TargetPersonaId,
    ml.MarketingListName as [Name],
    ml.TotalAccounts,
    ml.TotalDecisionMakers,
    REPLACE(ml.Locations, ',', ', ') Locations,
    REPLACE(ml.Seniority, ',', ', ') Seniority,
    REPLACE(ml.Functionality, ',', ', ') Functionality,
    ml.CreateDate,
    REPLACE(tp.Industries, ',', ', ') Industries,
    REPLACE(tp.Technologies, ',', ', ') Technologies,
    REPLACE(tp.Gics, ',', ', ') Gics,
    REPLACE(tp.Revenues, ',', ', ') Revenues,
    REPLACE(tp.EmployeeCounts, ',', ', ') EmployeeCounts,
	count(*) over(partition by ml.CreatedBy) as TotalRecords
  FROM MarketingLists ml,
       TargetPersona tp
  WHERE ml.TargetPersonaId = tp.Id
  AND ml.CreatedBy = @UserId
  And (@Name = '' OR ml.MarketingListName LIKE '%' + @Name + '%')
  ORDER BY ml.Id DESC
  OFFSET (@PAGE * @SIZE) ROWS
  FETCH NEXT @SIZE ROWS ONLY

END
