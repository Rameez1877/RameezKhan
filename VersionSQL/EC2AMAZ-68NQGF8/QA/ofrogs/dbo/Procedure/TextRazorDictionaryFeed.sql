/****** Object:  Procedure [dbo].[TextRazorDictionaryFeed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TextRazorDictionaryFeed]
	-- Add the parameters for the stored procedure here
	@IndustryId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	select top(50) GW.Id,GW.Name from dbo.GoodWord GW where GW.IndustryId = @IndustryId
END
