/****** Object:  Table [dbo].[MarketingListFilterCopy]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingListFilterCopy](
	[TargetPersonaID] [int] NOT NULL,
	[Location] [varchar](100) NOT NULL,
	[Revenue] [varchar](100) NOT NULL,
	[EmployeeCount] [varchar](100) NOT NULL,
	[NoOfRecords] [int] NOT NULL,
	[Industry] [varchar](100) NOT NULL,
	[Seniority] [varchar](100) NULL,
	[Functionality] [varchar](500) NULL
) ON [PRIMARY]
