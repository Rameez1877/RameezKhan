/****** Object:  Procedure [dbo].[SaveMarketingListConfiguration_neeraj]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SaveMarketingListConfiguration_neeraj]
@targetpersonaid int
AS

BEGIN

insert into MarketingListCountry (UserId,TargetPersonaId,CountryId,MarketingListId)
select Distinct u.UserId,t.Id,u.CountryID,m.Id as MarketinglistId from targetpersona t,usertargetcountry u,MarketingLists m
where t.CreatedBy = u.UserId and t.Id = m.TargetPersonaId and t.Id = @targetpersonaid

insert into MarketingListTechnology (UserId,TargetPersonaId,Technology,MarketingListId)
select Distinct u.UserId,t.Id,u.Technology,m.Id as MarketinglistId from targetpersona t,usertargettechnology u,MarketingLists m
where t.CreatedBy = u.UserId and t.Id = m.TargetPersonaId and t.Id = @targetpersonaid

insert into MarketingListFunctionality (UserId,TargetPersonaId,Functionality,MarketingListId)
select Distinct u.UserId,t.Id,u.Functionality,m.Id as MarketinglistId from targetpersona t,usertargetfunctionality u,MarketingLists m
where t.CreatedBy = u.UserId and t.Id = m.TargetPersonaId and t.Id = @targetpersonaid

END
