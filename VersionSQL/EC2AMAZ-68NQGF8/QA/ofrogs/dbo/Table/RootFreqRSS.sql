/****** Object:  Table [dbo].[RootFreqRSS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RootFreqRSS](
	[RssFeedItemID] [int] NOT NULL,
	[RootWord] [varchar](100) NOT NULL,
	[WordFreq] [int] NULL,
 CONSTRAINT [RootFreqRSS_PK] PRIMARY KEY CLUSTERED 
(
	[RssFeedItemID] ASC,
	[RootWord] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
