/****** Object:  Table [dbo].[LeadScoreUserAuthorityFunction]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserAuthorityFunction](
	[UserID] [int] NOT NULL,
	[Functionality] [varchar](50) NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserAuthorityFunction] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserAuthorityFunction]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserAuthorityFunction] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserAuthorityFunction] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserAuthorityFunction]
