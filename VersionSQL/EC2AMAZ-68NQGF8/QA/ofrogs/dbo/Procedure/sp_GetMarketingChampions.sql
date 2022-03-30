/****** Object:  Procedure [dbo].[sp_GetMarketingChampions]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE dbo.sp_GetMarketingChampions
 (@ptype VARCHAR(50),
  @industryid VARCHAR(MAX),
  @PageNumber INT,
  @PageSize INT)
AS
BEGIN
  SET NOCOUNT ON;
 
select mkt.id, Username = mkt.name + ',' + mkt.designation,mkt.name, mkt.designation,mkt.summary,mkt.url,mkt.city,mkt.country,mkt.decisionmaker,
mkt.lastupdateddate,mkt.domainname, mkt.firstname,mkt.lastname,mkt.organization,mkt.state,mkt.linkedin_country,mkt.suggested_domainname,mkt.goldcustomer,
mkt.firstsuggested_domainname,mkt.emailid,mkt.emailgeneratedby,mkt.gendertype
from dbo.MktListDCIList as mkt where
mkt.decisionmaker = @ptype and 
 ','+@industryid+',' LIKE '%,'+CAST(mkt.industryid AS varchar)+',%'
order by mkt.name desc
 OFFSET @PageSize * (@PageNumber - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
