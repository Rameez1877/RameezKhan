/****** Object:  Procedure [dbo].[GetFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFunctionality]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select SubMarketingListName Name from [V_MarketingList] -- McDecisionmaker where IsActive=1 and Isoflist = 1 group by name;
	--union 
	--select Product from V_Products
	--union
	--select product from V_Solutions
END
