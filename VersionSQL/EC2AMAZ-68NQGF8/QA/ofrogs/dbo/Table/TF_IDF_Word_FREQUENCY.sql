﻿/****** Object:  Table [dbo].[TF_IDF_Word_FREQUENCY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TF_IDF_Word_FREQUENCY](
	[RssFeedItemId] [int] NOT NULL,
	[TermWord] [varchar](500) NOT NULL,
	[WordFreq] [varchar](100) NULL,
 CONSTRAINT [TF_IDF_Word_FREQUENCY_PK] PRIMARY KEY CLUSTERED 
(
	[RssFeedItemId] ASC,
	[TermWord] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]