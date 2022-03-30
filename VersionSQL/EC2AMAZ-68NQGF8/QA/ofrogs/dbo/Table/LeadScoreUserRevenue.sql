/****** Object:  Table [dbo].[LeadScoreUserRevenue]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserRevenue](
	[UserId] [int] NOT NULL,
	[Revenue] [varchar](30) NOT NULL,
	[Score] [int] NOT NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserRevenue] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserRevenue]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserRevenue] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserRevenue] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserRevenue]
