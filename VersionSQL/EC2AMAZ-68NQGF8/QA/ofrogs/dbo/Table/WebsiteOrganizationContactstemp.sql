/****** Object:  Table [dbo].[WebsiteOrganizationContactstemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrganizationContactstemp](
	[DecisionMakerId] [int] NULL,
	[OrganizationId] [int] NULL,
	[FirstName] [varchar](500) NULL,
	[LastName] [varchar](500) NULL,
	[Designation] [varchar](500) NULL,
	[Location] [varchar](500) NULL,
	[Url] [varchar](500) NULL,
	[Team] [varchar](200) NULL,
	[Functionality] [varchar](200) NULL
) ON [PRIMARY]
