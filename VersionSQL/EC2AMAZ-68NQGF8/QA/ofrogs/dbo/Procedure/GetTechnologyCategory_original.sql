/****** Object:  Procedure [dbo].[GetTechnologyCategory_original]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologyCategory_original]
@userId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	with cte as
(select count(*)
cnt from UserTargetTechnology
where UserId = @userId)
Select TSSC.id, TSSC.StackType as name FROM UserTargetTechnology UTT, TechStackTechnology TST, TechStackSubCategory TSSC
where UTT.UserId = @userId -- Parameter UserID
--and UTT.Technology = TST.StackTechnology
and UTT.Technology = TST.StackTechnologyName
and TST.StackSubCategoryID = TSSC.ID
group by TSSC.StackType,TSSC.id
UNION ALL
Select TSSC.id,TSSC.StackType as name FROM UserTargetTechnology UTT, TechStackTechnology TST, TechStackSubCategory TSSC, cte
where --UTT.Technology = TST.StackTechnology
UTT.Technology = TST.StackTechnologyName
and TST.StackSubCategoryID = TSSC.ID
and cte.cnt=0
group by TSSC.StackType,TSSC.id
END
