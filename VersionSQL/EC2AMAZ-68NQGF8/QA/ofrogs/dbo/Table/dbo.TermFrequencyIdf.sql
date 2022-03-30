/****** Object:  Table [dbo].[dbo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[dbo.TermFrequencyIdf](
	[Id] [int] NULL,
	[Word] [varchar](50) NULL,
	[IndustryId] [int] NULL,
	[TfIdf] [float] NULL
) ON [PRIMARY]
