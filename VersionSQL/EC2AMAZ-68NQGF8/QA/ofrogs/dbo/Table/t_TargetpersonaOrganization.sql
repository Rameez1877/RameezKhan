/****** Object:  Table [dbo].[t_TargetpersonaOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[t_TargetpersonaOrganization](
	[TargetPersonaId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
