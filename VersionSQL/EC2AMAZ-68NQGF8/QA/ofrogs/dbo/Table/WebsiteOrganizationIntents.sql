/****** Object:  Table [dbo].[WebsiteOrganizationIntents]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrganizationIntents](
	[IntentTopic] [varchar](100) NULL,
	[Category] [varchar](200) NULL,
	[Location] [varchar](200) NULL,
	[InvestmentType] [varchar](50) NULL,
	[Duration] [int] NULL,
	[OrganizationId] [int] NULL,
	[ID] [int] NULL
) ON [PRIMARY]
