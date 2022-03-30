/****** Object:  Table [dbo].[ProductPlanPricingFrequency]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProductPlanPricingFrequency](
	[PaymentFrequencyTypeID] [int] NOT NULL,
	[ProductPlanID] [int] NULL,
	[ProductPricingID] [int] NULL,
 CONSTRAINT [Pk_ProductPlanPricingFrequency] PRIMARY KEY CLUSTERED 
(
	[PaymentFrequencyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
