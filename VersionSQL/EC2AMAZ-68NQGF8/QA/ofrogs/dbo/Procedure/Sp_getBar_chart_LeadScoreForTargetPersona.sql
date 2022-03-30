/****** Object:  Procedure [dbo].[Sp_getBar_chart_LeadScoreForTargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_getBar_chart_LeadScoreForTargetPersona]
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @CreatedBy Int
	Select @CreatedBy= CreatedBy from Targetpersona WHERE id = @TargetPersonaId
    -- Insert statements for procedure here
	Select ordernum, sum(score0010 + score1020 + score2030 + score3040 + score4050 + score5060 + score6070 + score7080 + score8090 + score90100) as score from(

select 1 as ordernum,
 sum(case when totalscore between 0 and 10 then 1 else 0 end) score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App'
union all

select 2 as ordernum,
0 score0010,
 sum(case when totalscore between 11 and 20 then 1 else 0 end) score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App'
union all

select 3 as ordernum,
0 score0010,
0 score1020,
 sum(case when totalscore between 21 and 30 then 1 else 0 end) score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App' union all

select 4 as ordernum,
0 score0010,
0 score1020,
0 score2030,
 sum(case when totalscore between 31 and 40 then 1 else 0 end) score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App' union all

select 5 as ordernum,
0 score0010,
0 score1020,
0 score2030,
0 score3040,
 sum(case when totalscore between 41 and 50 then 1 else 0 end) score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App' union all

select 6 as ordernum,
0 score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
 sum(case when totalscore between 51 and 60 then 1 else 0 end) score5060,
0 score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App'union all


select 7 as ordernum,
0 score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
 sum(case when totalscore between 61 and 70 then 1 else 0 end) score6070,
0 score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App' union all

select 8 as ordernum,
0 score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
sum(case when totalscore between 71 and 80 then 1 else 0 end) score7080,
0 score8090,
0 score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App' union all

select 9 as ordernum,
0 score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
sum(case when totalscore between 81 and 90 then 1 else 0 end) score8090,
0 score90100

from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App'
union all
select 10 as order_num, 
0 score0010,
0 score1020,
0 score2030,
0 score3040,
0 score4050,
0 score5060,
0 score6070,
0 score7080,
0 score8090,
sum(case when totalscore >=91 then 1 else 0 end) score90100
from leadscore 
where OrganizationID in (select OrganizationID from targetpersonaorganization where targetpersonaid= @TargetPersonaId)
and userid=@CreatedBy
and type='Non App'
) a
group by ordernum

END
