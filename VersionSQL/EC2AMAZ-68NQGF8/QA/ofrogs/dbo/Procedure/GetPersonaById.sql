/****** Object:  Procedure [dbo].[GetPersonaById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonaById]
	@Id int = 1
AS
BEGIN
	SELECT Name from Persona where id=@Id;
END
