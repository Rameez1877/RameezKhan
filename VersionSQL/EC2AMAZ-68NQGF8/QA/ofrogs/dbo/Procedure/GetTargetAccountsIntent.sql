/****** Object:  Procedure [dbo].[GetTargetAccountsIntent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTargetAccountsIntent]
    @targetPersonaId int

AS 
/*
[dbo].[GetSurgeData] 300
[dbo].[GetSurgeData_anurag] 300
*/
BEGIN
    SET NOCOUNT ON;

    declare @AppRoleId INT, @Limit INT, @TechnologyCount INT, @UserId int

	Select @UserId = CreatedBy From TargetPersona where id = @targetPersonaId

    Select @TechnologyCount = count(*)
    from UserTargetTechnology
    WHERE UserId = @UserId

    select @AppRoleId = AppRoleId
    from appuser
    where id=@UserId

    SET @Limit = IIF(@AppRoleId = 3, 50, 999999)

        SELECT 
            S.Organization,
            S.OrganizationId,
            S.Industry,
            S.Functionality,
            S.Technology,
            S.TechnologyCategory,
            S.investmentType,
            S.CountryName,
            S.duration,
            S.Revenue,
			S.NOOFdecisionmaker
        FROM SurgeSummary S with (nolock)
		inner join TargetPersonaOrganization T
		on (T.OrganizationId = S.OrganizationId)
        WHERE S.CountryName IN (Select [Name]
            from UserTargetCountry U, Country C
            WHERE UserId = @UserId and u.countryid=c.id)
            AND S.Functionality IN (Select Functionality
            from UserTargetFunctionality
            WHERE UserId = @UserId)
            AND (@TechnologyCount = 0 OR Technology IN (Select technology
                from UserTargetTechnology
                WHERE UserId = @UserId
            union
                select 'NA' ))
            and (@AppRoleId <> 4 OR S.InvestmentType in ('Champion','Investment Made'))
			and T.TargetPersonaId = @targetPersonaId
        ORDER BY NOOFdecisionmaker DESC
END
