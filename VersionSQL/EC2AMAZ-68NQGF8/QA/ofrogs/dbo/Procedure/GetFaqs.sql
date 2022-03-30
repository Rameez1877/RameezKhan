/****** Object:  Procedure [dbo].[GetFaqs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetFaqs @Screen varchar(50)
/*
GetFaqs 'dashboard'
*/
AS
BEGIN

	SET NOCOUNT ON;

	Select *From FAQS where Screen = @Screen and Isactive = 1	
END
