/****** Object:  Procedure [dbo].[GetRegions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRegions]
AS
BEGIN
	SELECT * From Region where Id in(7,1,11,4) order by SortOrder
END
