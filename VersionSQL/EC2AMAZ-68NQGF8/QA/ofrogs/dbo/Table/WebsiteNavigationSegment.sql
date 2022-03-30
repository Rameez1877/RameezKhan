/****** Object:  Table [dbo].[WebsiteNavigationSegment]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteNavigationSegment](
	[WebsiteId] [int] NULL,
	[Product] [varchar](8000) NULL,
	[Solution] [varchar](8000) NULL,
	[Keyword] [varchar](1000) NULL,
	[Segment] [varchar](500) NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[WebsiteIntentKeywordCategoryID] [int] NULL,
	[KeywordCount] [int] NULL,
	[KeywordScore] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Partners] [varchar](4000) NULL,
 CONSTRAINT [PK_WebsiteNavigationSegment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
