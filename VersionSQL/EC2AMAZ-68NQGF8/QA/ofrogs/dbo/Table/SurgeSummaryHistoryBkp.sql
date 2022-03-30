/****** Object:  Table [dbo].[SurgeSummaryHistoryBkp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SurgeSummaryHistoryBkp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NULL,
	[Organization] [varchar](500) NULL,
	[IndustryID] [int] NULL,
	[Industry] [varchar](500) NULL,
	[Functionality] [varchar](100) NULL,
	[Technology] [varchar](100) NULL,
	[InvestmentType] [varchar](30) NULL,
	[CountryID] [int] NULL,
	[CountryName] [varchar](100) NOT NULL,
	[Duration] [int] NULL,
	[Surge] [int] NULL,
	[NoOfDecisionMaker] [int] NULL,
	[Revenue] [varchar](20) NULL,
	[EmployeeCount] [varchar](20) NULL,
	[TechnologyCategory] [varchar](100) NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]
