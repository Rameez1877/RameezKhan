/****** Object:  Table [dbo].[LeadScoreUserIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserIndustry](
	[UserId] [int] NOT NULL,
	[IndustryID] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[TYPE] [varchar](10) NOT NULL,
 CONSTRAINT [PK_LeadScoreUserIndustry] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[IndustryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserIndustry] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreUserIndustry]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserIndustry] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserIndustry] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserIndustry]
