/****** Object:  Table [dbo].[LeadScoreUserAuthorityScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserAuthorityScore](
	[UserId] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserAuthorityScore] ADD  DEFAULT ('NON App') FOR [TYPE]
