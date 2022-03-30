/****** Object:  Table [dbo].[LeadScoreUserAuthorityLevels]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserAuthorityLevels](
	[UserId] [int] NOT NULL,
	[Seniority] [varchar](30) NOT NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserAuthorityLevels] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserAuthorityLevels]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserAuthorityLevels] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserAuthorityLevels] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserAuthorityLevels]
