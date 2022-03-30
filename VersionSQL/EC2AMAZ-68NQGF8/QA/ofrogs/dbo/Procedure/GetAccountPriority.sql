/****** Object:  Procedure [dbo].[GetAccountPriority]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.GetAccountPriority 
	@Locations varchar(max) = '',
	@MarketingList varchar(max) = ''
AS
/*
dbo.GetAccountPriority 'India', 'Account Management'
*/
BEGIN
	select top 2001 LS.*, O.[Name] as OrganizationName, O.EmployeeCount, I.[Name] as IndustryName
	from 
		dbo.LeadScoreSubMarketingList LS
		inner join dbo.Organization O on O.Id = Ls.OrganizationId
		inner join dbo.Industry I on I.Id = O.IndustryId
	where
		(@MarketingList = '' or LS.SubMarketingListName in (select [Data] from dbo.Split(@MarketingList, ',')))
		and (@Locations = '' or LS.CountryName in (select [Data] from dbo.Split(@Locations, ',')))
	order by TotalScore desc
END
