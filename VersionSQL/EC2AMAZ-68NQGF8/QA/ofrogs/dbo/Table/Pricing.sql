/****** Object:  Table [dbo].[Pricing]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Pricing](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[Url] [varchar](500) NULL,
	[Price] [int] NULL,
	[PricingType] [varchar](500) NULL,
	[Line1] [nvarchar](2000) NULL,
	[Line2] [nvarchar](2000) NULL,
	[Line3] [nvarchar](2000) NULL,
	[Features] [nvarchar](4000) NULL,
	[BuyerCategory] [nvarchar](1000) NULL,
	[IsMostPopular] [bit] NULL,
	[IsActive] [bit] NULL,
	[Line4] [varchar](8000) NULL,
	[Line5] [varchar](8000) NULL,
	[Line6] [varchar](8000) NULL,
	[Line7] [varchar](8000) NULL,
	[Line8] [varchar](8000) NULL,
	[MinimumContractDuration] [varchar](300) NULL,
	[OnlyAvailablewithAnnualPlan] [varchar](300) NULL,
 CONSTRAINT [PK_Pricing] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Pricing] ADD  CONSTRAINT [DF_Pricing_IsPopular]  DEFAULT ((0)) FOR [IsMostPopular]
