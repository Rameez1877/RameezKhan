/****** Object:  Procedure [dbo].[Public_GetSurgeData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Public_GetSurgeData]
	@OrganizationName varchar(200) = null,
	@Opportunity varchar(200) = null
AS
/*
[dbo].[Public_GetSurgeData] 'CVS-Pharmacy', 'Retail'
*/
BEGIN
	SET NOCOUNT ON;
	set @OrganizationName = REPLACE(@OrganizationName, '-', ' ')

    SELECT top 10
        S.Organization,  
        S.OrganizationId,
		O.[Description],
		O.WebsiteUrl,
        S.Industry,
        S.Functionality,
        S.Technology,
        S.TechnologyCategory,
        S.InvestmentType,
        S.CountryName,
        S.Duration,
        S.Surge,
        S.Revenue,
        S.NoOfDecisionMaker
    FROM SurgeSummary S with (nolock)
		inner join Organization O with (nolock) on (O.Id = S.OrganizationId)
    WHERE 
		(Organization = @OrganizationName or @OrganizationName is null)
		and (Functionality = @Opportunity or @Opportunity is null)
    ORDER BY 
		NoOfDecisionMaker DESC, Surge DESC
END
