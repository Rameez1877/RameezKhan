/****** Object:  Table [dbo].[GlassdoorAward]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GlassdoorAward](
	[GDOrganizationID] [int] NULL,
	[Organization] [varchar](500) NULL,
	[Source_Website_Url] [varchar](500) NULL,
	[Year] [int] NULL,
	[AwardSource] [varchar](7000) NULL,
	[Title] [varchar](7000) NULL,
	[IsProcessed] [bit] NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[GlassdoorAward] ADD  DEFAULT ((0)) FOR [IsProcessed]
ALTER TABLE [dbo].[GlassdoorAward]  WITH CHECK ADD  CONSTRAINT [FK_GDOrganizationID] FOREIGN KEY([GDOrganizationID])
REFERENCES [dbo].[GlassdoorOrganization] ([ID])
ALTER TABLE [dbo].[GlassdoorAward] CHECK CONSTRAINT [FK_GDOrganizationID]
