/****** Object:  Table [dbo].[DocumentDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DocumentDetails](
	[id] [int] NULL,
	[Company] [varchar](1000) NULL,
	[AdministrativeAgent] [varchar](1000) NULL,
	[CollateralAgent] [varchar](1000) NULL,
	[SyndicationAgent] [varchar](1000) NULL,
	[CoDocumentationAgents] [varchar](1000) NULL,
	[Arrangers] [varchar](1000) NULL,
	[Borrower] [varchar](1000) NULL,
	[Holding] [varchar](1000) NULL,
	[DailyMargilLevel] [varchar](2000) NULL
) ON [PRIMARY]
