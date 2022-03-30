/****** Object:  Table [dbo].[AccountSegment]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AccountSegment](
	[OrganizationID] [int] NULL,
	[OrganizationName] [varchar](100) NULL,
	[MarketingList] [varchar](100) NULL,
	[SubMarketingList] [varchar](100) NULL,
	[ProfileCount] [int] NULL,
	[InsertedDate] [date] NULL
) ON [PRIMARY]
