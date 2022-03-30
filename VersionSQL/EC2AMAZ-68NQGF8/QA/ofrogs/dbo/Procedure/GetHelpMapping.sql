/****** Object:  Procedure [dbo].[GetHelpMapping]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 16 dec, 2020
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetHelpMapping]
AS
BEGIN
	select * from dbo.HelpMapping
	order by len(PlatformPath) desc
END
