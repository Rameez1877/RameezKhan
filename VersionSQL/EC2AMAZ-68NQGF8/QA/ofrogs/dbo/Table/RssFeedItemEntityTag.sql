/****** Object:  Table [dbo].[RssFeedItemEntityTag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeedItemEntityTag](
	[RssFeedItemId] [int] NOT NULL,
	[EntityName] [varchar](100) NOT NULL,
	[TagId] [int] NOT NULL,
 CONSTRAINT [Pk_RssFeedItemEntityTag] PRIMARY KEY CLUSTERED 
(
	[RssFeedItemId] ASC,
	[EntityName] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
