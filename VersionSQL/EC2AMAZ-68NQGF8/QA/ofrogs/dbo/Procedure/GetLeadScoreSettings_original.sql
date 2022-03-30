/****** Object:  Procedure [dbo].[GetLeadScoreSettings_original]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	Anurag Gandhi
-- Create date: 23 Jul, 2020
-- Description:	Gets the user settings fro LeadScore Configuration screen.//
-- =============================================
CREATE PROCEDURE [dbo].[GetLeadScoreSettings_original] 
	@UserId int
AS
/*
[dbo].[GetLeadScoreSettings] 2
*/
BEGIN
	SET NOCOUNT ON;

	select 'Functionality' as [FilterType], 0 as Id,NULL AS CategoryName  ,Functionality [Name], ApplyScore, 0 as IndustryGroupId
	from UserTargetFunctionality where UserId = @UserId
	union
	select 'Technology', 0 as Id,TSC.STACKTYPE as CategoryName , Technology, ApplyScore,  0 as IndustryGroupId
	from UserTargetTechnology UTS
	INNER JOIN TechStackTechnology TST
		ON TST.STACKTECHNOLOGYNAME = UTS.Technology
		INNER JOIN TechStackSubCategory TSC
		ON TSC.ID = TST.STACKSUBCATEGORYID
		where UserId = @UserId
	union
	select 'Industry', i.Id as Id,I.IndustryGroup AS CategoryName, I.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS, isnull(ApplyScore, 0), I.IndustryGroupId 
	from 
		Industry i
		left join UserTargetIndustry uti on (i.Id = uti.IndustryId and UserId = @UserId)
		
	where i.IsActive = 1 and ForLeadScore = 1
	and IndustryGroup is not null
	order by FilterType, CategoryName


	-- OLD
	--select 'Functionality' as [FilterType], 0 as Id, Functionality [Name], ApplyScore from UserTargetFunctionality where UserId = @UserId
	--union
	--select 'Technology', 0 as Id, Technology, ApplyScore from UserTargetTechnology where UserId = @UserId
	--union
	--select 'Industry', i.Id as Id, I.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS, isnull(ApplyScore, 0) 
	--from 
	--	Industry i
	--	left join UserTargetIndustry uti on (i.Id = uti.IndustryId and UserId = @UserId)
	--where i.IsActive = 1 and ForLeadScore = 1
	--order by FilterType, [Name]

END
