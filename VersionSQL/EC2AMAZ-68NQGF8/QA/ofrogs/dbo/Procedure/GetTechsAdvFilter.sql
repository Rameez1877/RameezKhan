/****** Object:  Procedure [dbo].[GetTechsAdvFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechsAdvFilter]
@techId int
AS
BEGIN

	SET NOCOUNT ON;

Select distinct TST.TagID, TST.StackTechnologyName as DataValues FROM TechStackTechnology TST, TechStackSubCategory TSSC
where TST.StackSubCategoryID = TSSC.ID
AND TSSC.ID = @techId 
and TST.IsActive = 1
END
