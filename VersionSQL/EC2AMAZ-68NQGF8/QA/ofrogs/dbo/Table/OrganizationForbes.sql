/****** Object:  Table [dbo].[OrganizationForbes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationForbes](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[YearForbes] [int] NULL,
	[OrganizationForbes] [varchar](100) NOT NULL,
	[OrganizationOF] [int] NULL,
	[SectorForbes] [varchar](100) NULL,
	[IndustryForbes] [varchar](100) NULL,
	[Region] [varchar](100) NULL,
	[CountryForbes] [varchar](100) NULL,
	[MarketValueForbes] [float] NULL,
	[SalesForbes] [float] NULL,
	[ProfitsForbes] [float] NULL,
	[AssetsForbes] [float] NULL,
	[RankForbes] [int] NULL,
	[WebsiteForbes] [varchar](200) NULL,
	[ForbesIndustryiD] [int] NULL
) ON [PRIMARY]
