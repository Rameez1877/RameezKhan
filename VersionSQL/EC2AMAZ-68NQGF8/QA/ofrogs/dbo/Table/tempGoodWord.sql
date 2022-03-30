/****** Object:  Table [dbo].[tempGoodWord]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tempGoodWord](
	[GdWd] [varchar](100) NOT NULL,
	[IndustryID] [int] NOT NULL,
	[RootWord] [varchar](100) NULL,
 CONSTRAINT [tempGoodWork_PK] PRIMARY KEY CLUSTERED 
(
	[GdWd] ASC,
	[IndustryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
