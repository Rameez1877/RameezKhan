/****** Object:  Table [dbo].[OutputTagScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OutputTagScore](
	[tagId] [int] NOT NULL,
	[tagName] [varchar](100) NOT NULL,
	[Score] [int] NOT NULL,
	[ScoreDate] [date] NOT NULL,
	[IndustryID] [int] NULL
) ON [PRIMARY]
