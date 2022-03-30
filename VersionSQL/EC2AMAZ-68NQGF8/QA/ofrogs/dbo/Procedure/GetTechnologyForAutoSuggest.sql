/****** Object:  Procedure [dbo].[GetTechnologyForAutoSuggest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologyForAutoSuggest] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT distinct Technology as DataValues from V_Technology
	--Select distinct StackTechnologyName as StackTechnology FROM TechStackTechnology
	--where IsActive = 1
END
