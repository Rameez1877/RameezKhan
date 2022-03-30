/****** Object:  Table [dbo].[UserCredit]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserCredit](
	[UserID] [int] NULL,
	[CreditsBalanceAtLastInventory] [varchar](250) NULL,
	[CreditConsumedorGained] [int] NULL,
	[TransactionDate] [datetime] NULL,
	[CreditTransactionID] [int] NULL,
	[PlanID] [int] NULL
) ON [PRIMARY]
