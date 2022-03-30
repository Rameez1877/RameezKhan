/****** Object:  Procedure [dbo].[GetTechnoDashBoardDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<asef>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnoDashBoardDetail] 
	-- Add the parameters for the stored procedure here
	@searchText varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select h.technology, h.NoOfCountry, h.NoOfCompany, h.NoOfIndustry,
		   d.SectionName, d.DataValue, d.PercentValue, d.OrderNumber
	from 
		   TechnoGraphicsDashBoardHeader h with (nolock), TechnoGraphicsDashBoardDetail d with (nolock)
    where
		         h.Technology = @searchText
	and 
		         d.Technology = @searchText

END
