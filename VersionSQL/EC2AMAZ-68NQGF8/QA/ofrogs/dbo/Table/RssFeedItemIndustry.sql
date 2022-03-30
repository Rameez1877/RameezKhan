﻿/****** Object:  Table [dbo].[RssFeedItemIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeedItemIndustry](
	[RssFeedItemId] [int] NOT NULL,
	[IndustryId] [int] NOT NULL,
	[TextRazorRunDate] [datetime] NULL,
 CONSTRAINT [PK_RssFeedItemIndustry] PRIMARY KEY CLUSTERED 
(
	[RssFeedItemId] ASC,
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Ak_RssFeedItemIndustry] UNIQUE NONCLUSTERED 
(
	[RssFeedItemId] ASC,
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]