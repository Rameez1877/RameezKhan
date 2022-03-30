/****** Object:  Procedure [dbo].[GetSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSummary]
	@PersonaId int,
	@RegionId int
AS
BEGIN
	SELECT Name from Persona where id=@PersonaId
	SELECT Name from Region where id=@RegionId;
END
