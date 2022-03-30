/****** Object:  Procedure [dbo].[getBar_chart_LeadScoreForTargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE getBar_chart_LeadScoreForTargetPersona
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
Select sum(case when totalscore between 60 and 70 then 1
else 0 end) '60-70',

sum(case when totalscore between 70 and 80 then 1
else 0 end) '70-80',


sum(case when totalscore between 80 and 90 then 1
else 0 end) '80-90',

sum(case when totalscore >=90 then 1
else 0 end) '90-100'

 from leadscore 
where  OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)


END
