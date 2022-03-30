/****** Object:  Procedure [dbo].[TechStackSubCategoryAdvFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TechStackSubCategoryAdvFilter]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select id,StackType as name from TechStackSubCategory
    where id in(

	select stacksubcategoryid from TechStackTechnology)
END
