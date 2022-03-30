/****** Object:  Procedure [dbo].[TextRazorIndustryList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[TextRazorIndustryList] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Id from Industry where Id in (36)
END
