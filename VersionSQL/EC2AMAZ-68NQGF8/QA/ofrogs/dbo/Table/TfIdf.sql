/****** Object:  Table [dbo].[TfIdf]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TfIdf](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedItemId] [int] NOT NULL,
	[IndustryId] [int] NOT NULL,
	[Word] [varchar](500) NOT NULL,
	[Frequency] [int] NOT NULL,
	[Tf] [float] NULL,
	[Idf] [float] NULL,
	[TfIdf] [float] NULL,
 CONSTRAINT [PK_TfIdf] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
