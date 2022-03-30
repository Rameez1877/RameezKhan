/****** Object:  Table [ofuser].[AppUserTopic]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ofuser].[AppUserTopic](
	[AppUserId] [int] NOT NULL,
	[TopicName] [varchar](100) NULL,
	[LabelName] [varchar](100) NULL,
	[ProductName] [varchar](100) NOT NULL
) ON [PRIMARY]
