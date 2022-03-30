/****** Object:  Procedure [dbo].[SaveLeadScoreSettings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	Anurag Gandhi
-- Create date: 23 Jul, 2020
-- Description:	Saves the user settings fro LeadScore Configuration screen.//
-- =============================================
CREATE PROCEDURE [dbo].[SaveLeadScoreSettings] 
	@UserId int,
	@Functionalities varchar(max),
	@Technologies varchar(max),
	@Industries varchar(max)
AS
/*
[dbo].[GetLeadScoreSettings] 2
*/
BEGIN
	SET NOCOUNT ON;
	Update UserTargetFunctionality set ApplyScore = 0 where UserId = @UserId
	Update UserTargetTechnology set ApplyScore = 0 where UserId = @UserId
	Update UserTargetIndustry set ApplyScore = 0 where UserId = @UserId

	Update UserTargetFunctionality set ApplyScore = 1 where UserId = @UserId
	and Functionality in (select [value] from string_split(@Functionalities, ';'))

	Update UserTargetTechnology set ApplyScore = 1 where UserId = @UserId
	and Technology in (select [value] from string_split(@Technologies, ';'))

	Update UserTargetIndustry set ApplyScore = 1 where UserId = @UserId
	and IndustryId in (select [value] from string_split(@Industries, ';'))

	insert UserTargetIndustry 
	select @UserId, [value], 1 from string_split(@Industries, ';')
	where
		[value] not in (select IndustryId from UserTargetIndustry where UserId = @UserId)
END
