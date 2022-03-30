/****** Object:  Procedure [dbo].[SaveLeadScoreSettingsSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	ASEf DAQIQ
-- Create date: 3 Aug, 2021
-- Description:	Saves the user settings fro LeadScore Configuration screen.//
-- =============================================
CREATE PROCEDURE [dbo].[SaveLeadScoreSettingsSummary] 
	@UserId int,
	@Functionalities varchar(max),
	@Technologies varchar(max),
	@Industries varchar(max),
	@TargetPersonaId int
AS
/*
[dbo].[GetLeadScoreSettings] 2
*/
BEGIN
	SET NOCOUNT ON;

	if @Functionalities <> '' begin
	delete from UserTargetFunctionality where TargetPersonaId = @TargetPersonaId
	Insert into UserTargetFunctionality  (UserID,Functionality, ApplyScore, TargetPersonaId) 
	SELECT @UserId, value , 1, @TargetPersonaId
	FROM   STRING_SPLIT(@Functionalities, ';')
	end

	if @Technologies <> '' begin
	delete from UserTargetTechnology where TargetPersonaId = @TargetPersonaId
	Insert into UserTargetTechnology  (UserID,Technology, ApplyScore, TargetPersonaId) 
	SELECT @UserId, value , 1, @TargetPersonaId
	FROM   STRING_SPLIT(@Technologies, ';')
	end
	
	if @Industries <> '' begin
	delete from UserTargetIndustry where TargetPersonaId = @TargetPersonaId
	Insert into UserTargetIndustry  (UserID,IndustryId, ApplyScore, TargetPersonaId) 
	SELECT @UserId, value , 1, @TargetPersonaId
	FROM   STRING_SPLIT(@Industries, ';')
	end
	
END
