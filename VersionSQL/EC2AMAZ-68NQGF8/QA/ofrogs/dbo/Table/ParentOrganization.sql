/****** Object:  Table [dbo].[ParentOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ParentOrganization](
	[OrganizationId] [int] NOT NULL,
	[OrganizationName] [varchar](100) NOT NULL,
	[URL] [varchar](500) NULL,
	[ParentOrganizationId] [int] NULL,
	[ParentOrganizationName] [varchar](500) NULL,
	[IsParent] [varchar](1) NULL,
	[IsChild] [varchar](1) NULL,
	[StepNumber] [int] NULL,
	[IndustryID] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ParentOrganization] ADD  DEFAULT ('N') FOR [IsParent]
ALTER TABLE [dbo].[ParentOrganization] ADD  DEFAULT ('N') FOR [IsChild]
