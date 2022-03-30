/****** Object:  Procedure [dbo].[GetUserCreditStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserCreditStatus] @UserID int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @SubscriptionStartDate date,
          @SubscriptionEndDate date,
		  @AllotedOrganizationCredit int,
          @OrganizationCreditsSpent int,
          @OrganizationCreditsRemaining int,
		  @OrganizationName VARCHAR(100)
  SELECT
    @AllotedOrganizationCredit = oc.CreditsPurchased,
    @SubscriptionStartDate = Oc.SubscriptionStartDate,
    @SubscriptionEndDate = Oc.SubscriptionEndDate,
	@OrganizationName = OC.OrganizationName
  FROM OrganizationCredit OC,
       AppUser AU
  WHERE OC.OrganizationName = AU.OrganizationName
  AND AU.ID = @UserID
  AND CONVERT(date, GETDATE())
  BETWEEN Oc.SubscriptionStartDate AND Oc.SubscriptionEndDate
  AND OC.IsActive = 1

  If @@ROWCOUNT = 0
  begin
  SET @AllotedOrganizationCredit = 0
   SET @SubscriptionStartDate = null
   SET @SubscriptionEndDate =null
  end 
 
  CREATE TABLE #TempSurgeContactDetail
  (ID INT)

  INSERT INTO #TempSurgeContactDetail
  SELECT ID from SurgeContactDetail
  WHERE UserID IN (SELECT
    AU.ID
  FROM OrganizationCredit OC,
       AppUser AU
  WHERE OC.OrganizationName = AU.OrganizationName
  AND OC.OrganizationName = @OrganizationName
  AND CONVERT(date, GETDATE())
  BETWEEN Oc.SubscriptionStartDate AND Oc.SubscriptionEndDate
  AND OC.IsActive = 1
  AND CONVERT(date, EmailGeneratedDate) BETWEEN @SubscriptionStartDate AND @SubscriptionEndDate)
  AND len(Emailid) > 5
  SELECT
  
    @OrganizationCreditsSpent = COUNT(*)
  FROM SurgeContactDetail SC
  WHERE Sc.ID IN (SELECT
    ID FROM #TempSurgeContactDetail)

	  IF @OrganizationCreditsSpent is null
  SET @OrganizationCreditsSpent = 0
   
  SET @OrganizationCreditsRemaining = @AllotedOrganizationCredit - @OrganizationCreditsSpent
  SELECT
    --0 AllotedUserCredit,
    --0 UserCreditsSpent,
    --0 UserCreditsRemaining,
    @AllotedOrganizationCredit AllotedOrganizationCredit,
    @OrganizationCreditsSpent OrganizationCreditsSpent,
    @OrganizationCreditsRemaining OrganizationCreditsRemaining

END
