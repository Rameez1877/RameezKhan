/****** Object:  Table [dbo].[TermFrequencyIDF]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TermFrequencyIDF](
	[Id] [int] NULL,
	[Word] [nvarchar](50) NULL,
	[IndustryId] [int] NULL,
	[tfIDF] [numeric](18, 0) NULL
) ON [PRIMARY]
