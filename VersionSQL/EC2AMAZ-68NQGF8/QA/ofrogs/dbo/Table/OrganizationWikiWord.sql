/****** Object:  Table [dbo].[OrganizationWikiWord]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationWikiWord](
	[OrganizationId] [int] NOT NULL,
	[WikiWordId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[WikiWordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationWikiWord]  WITH NOCHECK ADD  CONSTRAINT [FK_OrgWikiWords_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
ON DELETE CASCADE
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationWikiWord] CHECK CONSTRAINT [FK_OrgWikiWords_Organization]
ALTER TABLE [dbo].[OrganizationWikiWord]  WITH CHECK ADD  CONSTRAINT [FK_OrgWikiWords_WikiWords] FOREIGN KEY([WikiWordId])
REFERENCES [dbo].[WikiWord] ([Id])
ON DELETE CASCADE
ALTER TABLE [dbo].[OrganizationWikiWord] CHECK CONSTRAINT [FK_OrgWikiWords_WikiWords]
