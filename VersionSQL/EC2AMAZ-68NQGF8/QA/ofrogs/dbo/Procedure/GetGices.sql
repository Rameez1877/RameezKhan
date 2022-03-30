/****** Object:  Procedure [dbo].[GetGices]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetGices
AS
BEGIN

	SET NOCOUNT ON;
	
	Select g.CountryID as [Key], C.[Name], C.Code from GicOrganization g
	inner join Country c on g.CountryID = c.id
	group by g.CountryID, c.[Name], c.Code
END
