/****** Object:  Table [dbo].[OutputTokens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OutputTokens](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedItemId] [int] NOT NULL,
	[Token] [nvarchar](500) NULL,
	[Frequency] [int] NULL,
	[updateDate] [datetime] NULL,
 CONSTRAINT [PK_OutputTokens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OutputTokens]  WITH NOCHECK ADD  CONSTRAINT [FK_OutputTokens_RssFeedItem] FOREIGN KEY([RssFeedItemId])
REFERENCES [dbo].[RssFeedItem] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OutputTokens] CHECK CONSTRAINT [FK_OutputTokens_RssFeedItem]
