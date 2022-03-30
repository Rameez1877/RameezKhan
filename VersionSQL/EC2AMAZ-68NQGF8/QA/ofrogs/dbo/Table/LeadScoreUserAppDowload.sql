/****** Object:  Table [dbo].[LeadScoreUserAppDowload]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserAppDowload](
	[UserId] [int] NULL,
	[NoOfDownloads] [varchar](20) NULL,
	[Score] [int] NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserAppDowload] ADD  DEFAULT ('App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserAppDowload]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserAppDowload] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserAppDowload] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserAppDowload]
