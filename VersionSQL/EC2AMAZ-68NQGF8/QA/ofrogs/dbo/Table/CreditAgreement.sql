/****** Object:  Table [dbo].[CreditAgreement]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CreditAgreement](
	[DocID] [int] NULL,
	[FacilityType] [varchar](100) NULL,
	[FacilityAmount] [varchar](100) NULL,
	[LiborSpread] [varchar](100) NULL,
	[PrimeSpread] [varchar](100) NULL,
	[PricingGrid] [varchar](100) NULL,
	[CommitmentFee] [varchar](100) NULL,
	[PricingGridType] [varchar](100) NULL,
	[LiborSpreadValue] [varchar](100) NULL,
	[PrimeSpreadValue] [varchar](100) NULL,
	[IntiallyAtTheHighest_UnDrawn] [varchar](100) NULL
) ON [PRIMARY]
