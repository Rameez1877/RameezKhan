/****** Object:  Table [dbo].[WebsiteOrgTechnologies]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrgTechnologies](
	[OrganizationId] [int] NULL,
	[Technology] [varchar](300) NULL,
	[Category] [varchar](300) NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
