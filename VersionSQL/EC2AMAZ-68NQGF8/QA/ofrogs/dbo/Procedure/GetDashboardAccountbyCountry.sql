/****** Object:  Procedure [dbo].[GetDashboardAccountbyCountry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE GetDashboardAccountByCountry
	@UserId int = 2
AS
BEGIN
	SET NOCOUNT ON;
	declare @PersonaIds varchar(100)

	SELECT @PersonaIds = PersonaIds from AppUser where Id = @UserId

	select Category into #Category from AdoptionFramework where PersonaTypeId in (select trim([value]) from string_split(@PersonaIds, ','))
	
	select top 4 Name as [Name] ,count(1) as [Value] from Country
	group by Name
	order by 2 desc

END
