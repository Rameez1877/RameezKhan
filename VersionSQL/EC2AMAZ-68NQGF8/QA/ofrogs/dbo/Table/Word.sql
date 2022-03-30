/****** Object:  Table [dbo].[Word]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Word](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedItemId] [int] NOT NULL,
	[Stem] [varchar](50) NULL,
	[Lemma] [varchar](50) NULL,
	[PartOfSpeech] [varchar](50) NULL,
	[Token] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Word]  WITH NOCHECK ADD  CONSTRAINT [Fk_Word_RssFeedItem] FOREIGN KEY([RssFeedItemId])
REFERENCES [dbo].[RssFeedItem] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Word] CHECK CONSTRAINT [Fk_Word_RssFeedItem]
