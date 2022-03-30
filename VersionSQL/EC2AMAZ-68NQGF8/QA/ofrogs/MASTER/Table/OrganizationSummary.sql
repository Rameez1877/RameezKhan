/****** Object:  Table [MASTER].[OrganizationSummary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [MASTER].[OrganizationSummary](
	[OrganizationID] [int] NULL,
	[TechnologyFunctionalityID] [int] NULL
) ON [PRIMARY]

ALTER TABLE [MASTER].[OrganizationSummary]  WITH CHECK ADD FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([Id])
ALTER TABLE [MASTER].[OrganizationSummary]  WITH CHECK ADD FOREIGN KEY([TechnologyFunctionalityID])
REFERENCES [MASTER].[TechTeamIntent] ([ID])
