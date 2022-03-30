/****** Object:  Procedure [dbo].[GetDashboardAccountsByIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetDashboardAccountsByIndustry
	@UserId int = 2
AS
BEGIN
	SET NOCOUNT ON;
	declare @PersonaIds varchar(100)

	SELECT @PersonaIds = PersonaIds from AppUser where Id = @UserId
	
	select top 4 Functionality as [Name], count(1) as [Value] from AdoptionFramework where PersonaTypeId in (select trim([value]) from string_split(@PersonaIds, ','))
	group by Functionality
	order by 2 desc

END
