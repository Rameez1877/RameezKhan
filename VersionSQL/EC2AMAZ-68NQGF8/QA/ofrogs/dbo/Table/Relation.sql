/****** Object:  Table [dbo].[Relation]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Relation](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedItemId] [int] NULL,
	[Predicate] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Relation]  WITH NOCHECK ADD  CONSTRAINT [Fk_Relation_RssFeedItem] FOREIGN KEY([RssFeedItemId])
REFERENCES [dbo].[RssFeedItem] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Relation] CHECK CONSTRAINT [Fk_Relation_RssFeedItem]
