/****** Object:  Procedure [dbo].[sp_DecisionMakerTotalCount]    Committed by VersionSQL https://www.versionsql.com ******/

--GetFilterCount
Create PROCEDURE [dbo].[sp_DecisionMakerTotalCount]
 (@ptype VARCHAR(50),
  @plisttype VARCHAR(80),
  @industryid VARCHAR(MAX)
 )
AS
BEGIN
  SET NOCOUNT ON;
  select distinct count(*)  from MarketingListDCIList mkt where
   ','+@industryid+',' LIKE '%,'+CAST(mkt.industryid AS varchar)+',%' and mkt.decisionmaker=@ptype
 and  mkt.marketinglist_name = @plisttype
END
