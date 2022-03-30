/****** Object:  Table [dbo].[LeadScoreUserAppCategory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserAppCategory](
	[UserId] [int] NULL,
	[AppCategoryId] [int] NULL,
	[Score] [int] NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserAppCategory] ADD  DEFAULT ('App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserAppCategory]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserAppCategory] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserAppCategory] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserAppCategory]
