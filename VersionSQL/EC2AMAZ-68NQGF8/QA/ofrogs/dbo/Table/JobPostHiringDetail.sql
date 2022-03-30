/****** Object:  Table [dbo].[JobPostHiringDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobPostHiringDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NULL,
	[FocusArea] [varchar](200) NULL,
	[JobTitle] [varchar](500) NULL,
	[location] [varchar](500) NULL,
	[Country] [varchar](200) NULL
) ON [PRIMARY]
