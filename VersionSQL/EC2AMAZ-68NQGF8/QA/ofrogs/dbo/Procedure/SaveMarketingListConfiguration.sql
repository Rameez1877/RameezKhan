/****** Object:  Procedure [dbo].[SaveMarketingListConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SaveMarketingListConfiguration]
@targetpersonaid int,
@userId int,
@marketingListId int
AS

BEGIN

insert into MarketingListCountry (UserId,TargetPersonaId,CountryId,MarketingListId)
select Distinct @userId,@targetpersonaid,u.CountryID,@marketingListId  from ConfiguredCountry u
where u.userId = @userId and u.TargetPersonaId = @targetpersonaid

insert into MarketingListTechnology (UserId,TargetPersonaId,Technology,MarketingListId)
select Distinct @userId,@targetpersonaid,u.Technology,@marketingListId from ConfiguredTechnology u
where u.UserId = @userId and u.TargetPersonaId = @targetpersonaid

insert into MarketingListFunctionality (UserId,TargetPersonaId,Functionality,MarketingListId)
select Distinct  @userId,@targetpersonaid,u.Functionality,@marketingListId  from Configuredfunctionality u
where  u.UserId = @userId and u.TargetPersonaId = @targetpersonaid

END

--select *from MarketingListTechnology
