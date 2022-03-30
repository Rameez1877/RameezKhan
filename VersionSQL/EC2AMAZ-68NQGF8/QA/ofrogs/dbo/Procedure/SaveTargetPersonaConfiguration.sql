/****** Object:  Procedure [dbo].[SaveTargetPersonaConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SaveTargetPersonaConfiguration]
@TargetPersonaId int,
@UserId int
AS

BEGIN

insert into ConfiguredCountry (UserId,TargetPersonaId,CountryId)
select Distinct @userId,@TargetPersonaId,u.CountryID from usertargetcountry u
where u.UserId = @userId

insert into ConfiguredTechnology (UserId,TargetPersonaId,Technology)
select Distinct @userId,@TargetPersonaId,u.Technology from usertargettechnology u
where u.UserId = @userId

insert into ConfiguredFunctionality (UserId,TargetPersonaId,Functionality)
select Distinct  @userId,@TargetPersonaId,u.Functionality from usertargetfunctionality u
where u.UserId = @userId

--exec [dbo].[PopulateMarketingListFilterSummary] @targetpersonaid

END
