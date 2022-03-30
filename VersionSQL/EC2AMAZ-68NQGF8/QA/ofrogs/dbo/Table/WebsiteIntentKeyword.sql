/****** Object:  Table [dbo].[WebsiteIntentKeyword]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteIntentKeyword](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Keyword] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[Segment] [varchar](100) NULL,
	[WebsiteIntentKeywordCategoryID] [int] NULL,
	[Score] [tinyint] NOT NULL,
 CONSTRAINT [Pk_WebsiteIntentKeyword] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_WebsiteIntentKeyword] UNIQUE NONCLUSTERED 
(
	[Keyword] ASC,
	[Segment] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
