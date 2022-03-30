/****** Object:  Table [MASTER].[ContactListSummary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [MASTER].[ContactListSummary](
	[LinkedInID] [int] NOT NULL,
	[TypeID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[ResultantCountryId] [int] NULL,
	[EmailID] [varchar](500) NULL,
	[SeniorityLevel] [varchar](100) NULL
) ON [PRIMARY]

ALTER TABLE [MASTER].[ContactListSummary]  WITH CHECK ADD FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([Id])
ALTER TABLE [MASTER].[ContactListSummary]  WITH CHECK ADD FOREIGN KEY([TypeID])
REFERENCES [MASTER].[TechTeamIntent] ([ID])
