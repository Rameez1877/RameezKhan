/****** Object:  Table [dbo].[LeadScoreLinkedInCountry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreLinkedInCountry](
	[UserID] [int] NULL,
	[CountryName] [varchar](100) NULL,
	[TYPE] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreLinkedInCountry] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScoreLinkedInCountry]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreLinkedInCountry] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreLinkedInCountry] CHECK CONSTRAINT [CHK_TYPE_LeadScoreLinkedInCountry]
