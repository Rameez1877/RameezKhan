/****** Object:  Procedure [dbo].[QA_GetOrganizationNotes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetOrganizationNotes]
@OrganizationId INT,
@UserId INT
AS
/*
[dbo].GetOrganizationNotes  75121, 326
*/
BEGIN

	SET NOCOUNT ON;

	Select o.*, a.Name as UserName from OrganizationNotes o
	inner join AppUser a on (a.Id = o.UserId)
	and o.organizationId =  @OrganizationId
	and o.UserId = @UserId
	order by o.Id desc

END
