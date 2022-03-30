/****** Object:  Table [dbo].[OrganizationCredit]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationCredit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationName] [varchar](100) NOT NULL,
	[PricePerCredit] [decimal](5, 2) NOT NULL,
	[SubscriptionStartDate] [date] NOT NULL,
	[SubscriptionEndDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreditsPurchased] [int] NOT NULL,
	[CreditWarningDays] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationCredit] ADD  DEFAULT ((1)) FOR [IsActive]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[Trg_OrganizationCredit] 
   ON  [dbo].[OrganizationCredit] 
   AFTER INSERT,UPDATE
AS 
BEGIN
SET NOCOUNT ON;
Declare @StartDate Date, @EndDate Date, @OrganizationName VARCHAR(100),@DuplicateCount INT, @ErrorMessage VARCHAR(200)
Select @StartDate  = SubscriptionStartDate,
@EndDate = SubscriptionEndDate,
@OrganizationName = OrganizationName  from OrganizationCredit
--
-- Validate from and to dates
--
If @EndDate < @StartDate
BEGIN
        RAISERROR ('Start date is greater than end date ' ,10,1)
        ROLLBACK TRANSACTION
END

--
-- Date overlap validation
--  

--SELECT @DuplicateCount = COUNT(*) FROM OrganizationCredit o1
--WHERE EXISTS
--(
--    SELECT 1 FROM OrganizationCredit o2
--    WHERE (
--            o2.SubscriptionStartDate BETWEEN o1.SubscriptionStartDate AND o1.SubscriptionEndDate
--            OR o2.SubscriptionEndDate BETWEEN o1.SubscriptionStartDate AND o1.SubscriptionEndDate
--            OR o1.SubscriptionStartDate BETWEEN o2.SubscriptionStartDate AND o2.SubscriptionEndDate
--            OR o1.SubscriptionEndDate BETWEEN o2.SubscriptionStartDate AND o2.SubscriptionEndDate
--        )
--		and o2.OrganizationName = @OrganizationName
--    AND o2.id != o1.id
--	and o1.OrganizationName = @OrganizationName
--)

--If @DuplicateCount <> 0 
--BEGIN
--	    SET @ErrorMessage = 'Invalid Entry. Date combination is overlapping with other records for :' + @OrganizationName
--        RAISERROR (@ErrorMessage  ,10,1)
--        ROLLBACK TRANSACTION
--END

--select * from OrganizationCredit
--delete OrganizationCredit where id = 18
--insert into OrganizationCredit
--values ('test',0.5,'2020-04-12','2020-05-31',1,1,1)

END

ALTER TABLE [dbo].[OrganizationCredit] ENABLE TRIGGER [Trg_OrganizationCredit]
