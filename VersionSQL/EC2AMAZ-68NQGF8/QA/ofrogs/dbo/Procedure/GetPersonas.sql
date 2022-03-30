/****** Object:  Procedure [dbo].[GetPersonas]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetPersonas
AS
BEGIN

	SET NOCOUNT ON;

	select Id,
	Name,
	IsTechnology,
	len(Name) as PersonaLength
		from Persona where Isactive=1 order by isTechnology asc --, PersonaLength asc
END
