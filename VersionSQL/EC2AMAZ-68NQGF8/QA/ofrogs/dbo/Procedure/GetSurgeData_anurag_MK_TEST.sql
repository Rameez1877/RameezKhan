/****** Object:  Procedure [dbo].[GetSurgeData_anurag_MK_TEST]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurgeData_anurag_MK_TEST]
    @UserId Int = 1
AS
/*
[dbo].[GetSurgeData] 300
[dbo].[GetSurgeData_anurag] 300
-- 174801
*/
BEGIN
    SET NOCOUNT ON;

    declare @AppRoleId INT, @Limit INT, @TechnologyCount INT

    Select @TechnologyCount = count(*)
    from UserTargetTechnology
    WHERE UserId = @UserId

    select @AppRoleId = AppRoleId
    from appuser
    where id=@UserId

    SET @Limit = IIF(@AppRoleId = 3, 50, 999999)

        SELECT top (@Limit)
            Organization ,
            OrganizationId,
            Industry,
            Functionality,
            Technology,
            TechnologyCategory,
            InvestmentType,
            CountryName,
            Duration,
            Surge,
            Revenue,
            NoOfDecisionMaker
        FROM SurgeSummary with (nolock)
        WHERE (@TechnologyCount = 0 OR Technology IN (Select technology
                from UserTargetTechnology with (nolock)
                WHERE UserId = @UserId
            union
                select 'NA' ))
            and (@AppRoleId <> 4 OR InvestmentType in ('Champion','Investment Made'))
			AND
		CountryId IN (Select CountryId from UserTargetCountry  with (nolock) WHERE UserId = @UserId)
            AND 
			
		Functionality IN (Select Functionality from UserTargetFunctionality with (nolock)
            WHERE UserId = @UserId)
             
        ORDER BY NoOfDecisionMaker DESC, Surge DESC
END
