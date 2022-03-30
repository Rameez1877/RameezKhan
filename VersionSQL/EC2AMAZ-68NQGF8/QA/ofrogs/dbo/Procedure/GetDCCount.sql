/****** Object:  Procedure [dbo].[GetDCCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDCCount]
	@UserId int   
AS      
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 25 May, 2019      
-- Updated date: 25 May, 2019      
-- Description: Gets the Magazine Data.//      
-- =============================================      
-- [GetDCCount] 2      
BEGIN
	declare @Industrys varchar(500)
	select @Industrys = IndustryId from AppUserIndustry where UserId = @UserId

	select decisionmaker as DecisionMaker, count(1) as [Count] from Linkedindata
	where
		IndustryId in (select [Data] from dbo.Split(@Industrys, ','))
		and decisionmaker in ('DecisionMaker', 'Influencer', 'Unknown')
	group by decisionmaker
END      
