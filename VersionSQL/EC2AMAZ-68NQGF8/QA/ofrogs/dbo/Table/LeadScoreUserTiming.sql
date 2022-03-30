/****** Object:  Table [dbo].[LeadScoreUserTiming]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserTiming](
	[UserID] [int] NULL,
	[SeniorityLevel] [varchar](100) NULL,
	[ScoreKeywordJobTitle] [int] NULL,
	[ScoreKeywordSummary] [int] NULL,
	[Type] [varchar](10) NULL
) ON [PRIMARY]
