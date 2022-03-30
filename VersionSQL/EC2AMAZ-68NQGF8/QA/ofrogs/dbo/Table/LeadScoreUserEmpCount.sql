/****** Object:  Table [dbo].[LeadScoreUserEmpCount]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserEmpCount](
	[UserId] [int] NOT NULL,
	[EmpCount] [varchar](30) NOT NULL,
	[Score] [int] NOT NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserEmpCount] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserEmpCount]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserEmpCount] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserEmpCount] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserEmpCount]
