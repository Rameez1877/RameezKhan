/****** Object:  Table [dbo].[LeadScoreUserNeedPreference]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserNeedPreference](
	[UserID] [int] NOT NULL,
	[Preference] [varchar](25) NOT NULL,
	[TYPE] [varchar](10) NOT NULL,
	[Score] [int] NULL,
 CONSTRAINT [pk_LeadScoreUserNeedPreference] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[Preference] ASC,
	[TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserNeedPreference]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserNeedPreference] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserNeedPreference] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserNeedPreference]
