/****** Object:  Procedure [dbo].[GetIndustryGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetIndustryGroup]
AS
BEGIN
	SELECT *from IndustryGroup where IsActive=1
END


 
