/****** Object:  Procedure [dbo].[SaveTargetPersonaConfiguration_neeraj]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SaveTargetPersonaConfiguration_neeraj]
@targetpersonaid int
AS

BEGIN

insert into ConfiguredCountry (UserId,TargetPersonaId,CountryId)
select Distinct u.UserId,t.Id,u.CountryID from targetpersona t,usertargetcountry u
where t.CreatedBy = u.UserId and t.Id = @targetpersonaid

insert into ConfiguredTechnology (UserId,TargetPersonaId,Technology)
select Distinct u.UserId,t.Id,u.Technology from targetpersona t,usertargettechnology u
where t.CreatedBy = u.UserId and t.Id = @targetpersonaid

insert into ConfiguredFunctionality (UserId,TargetPersonaId,Functionality)
select Distinct u.UserId,t.Id,u.Functionality from targetpersona t,usertargetfunctionality u
where t.CreatedBy = u.UserId and t.Id = @targetpersonaid

END
