/****** Object:  Table [dbo].[ForbesData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ForbesData](
	[OrganizationID] [int] NULL,
	[SectorForbes] [nvarchar](100) NULL,
	[IndustryForbes] [nvarchar](100) NULL,
	[MarketValueForbes] [float] NULL,
	[YearForbes] [int] NULL,
	[SalesForbes] [float] NULL,
	[ProfitsForbes] [float] NULL,
	[Assets] [float] NULL,
	[OrganizationForbes] [nvarchar](100) NULL
) ON [PRIMARY]
