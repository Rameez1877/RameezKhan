/****** Object:  Table [dbo].[WebsiteOrganizationTouchpointsTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrganizationTouchpointsTemp](
	[DecisionMakerId] [int] NULL,
	[OrganizationId] [int] NULL,
	[Touchpoint] [varchar](200) NULL,
	[Functionality] [varchar](100) NULL
) ON [PRIMARY]
