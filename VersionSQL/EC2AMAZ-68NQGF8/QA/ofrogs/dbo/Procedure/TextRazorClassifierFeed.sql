/****** Object:  Procedure [dbo].[TextRazorClassifierFeed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TextRazorClassifierFeed] 
	-- Add the parameters for the stored procedure here
	@IndustryId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select C.Id as CategoryId,L.Name as CategoryLabelName,CW.Name as WordName from Category C join Label L on C.LabelId = L.Id 
	join LabelConceptWord LCW on LCW.LabelId = L.Id join ConceptWord CW on LCW.ConceptWordId = CW.Id
	where C.IndustryId = @IndustryId order by C.Id
END
