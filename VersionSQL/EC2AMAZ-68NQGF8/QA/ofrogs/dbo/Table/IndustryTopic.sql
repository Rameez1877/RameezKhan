/****** Object:  Table [dbo].[IndustryTopic]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustryTopic](
	[IndustryId] [int] NOT NULL,
	[TopicName] [varchar](300) NOT NULL,
	[isVisible] [int] NULL
) ON [PRIMARY]
