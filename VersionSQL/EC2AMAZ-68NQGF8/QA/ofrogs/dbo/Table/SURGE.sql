/****** Object:  Table [dbo].[SURGE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SURGE](
	[OrganizationID] [int] NULL,
	[Country] [varchar](max) NULL,
	[Industry] [varchar](max) NULL,
	[IndeedJobPostCompany] [varchar](max) NULL,
	[OrganizationName] [varchar](max) NULL,
	[SubMarketingList] [varchar](max) NULL,
	[Technology] [varchar](max) NULL,
	[Seniority] [varchar](max) NULL,
	[InvestmentType] [varchar](max) NULL,
	[JobDate] [date] NULL,
	[InsertedDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
