/****** Object:  Table [dbo].[ReviewDictionary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ReviewDictionary](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Sentiment] [varchar](max) NULL,
	[SentimentWord] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ReviewDictionary] ADD  DEFAULT (' ') FOR [Sentiment]
ALTER TABLE [dbo].[ReviewDictionary] ADD  DEFAULT (' ') FOR [SentimentWord]
