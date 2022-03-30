/****** Object:  Table [dbo].[Entity]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Entity](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EntityId] [varchar](100) NULL,
	[RssFeedItemId] [int] NOT NULL,
	[GoodWordId] [int] NULL,
	[ConfidenceScore] [decimal](20, 10) NULL,
	[RelevanceScore] [decimal](20, 10) NULL,
	[TagId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Ak_Entity] UNIQUE NONCLUSTERED 
(
	[RssFeedItemId] ASC,
	[EntityId] ASC,
	[GoodWordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [Fk_Entity_GoodWord] FOREIGN KEY([GoodWordId])
REFERENCES [dbo].[GoodWord] ([Id])
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [Fk_Entity_GoodWord]
ALTER TABLE [dbo].[Entity]  WITH NOCHECK ADD  CONSTRAINT [Fk_Entity_RssFeedItem] FOREIGN KEY([RssFeedItemId])
REFERENCES [dbo].[RssFeedItem] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [Fk_Entity_RssFeedItem]
ALTER TABLE [dbo].[Entity]  WITH NOCHECK ADD  CONSTRAINT [Fk_Entity_Tag] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tag] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [Fk_Entity_Tag]
