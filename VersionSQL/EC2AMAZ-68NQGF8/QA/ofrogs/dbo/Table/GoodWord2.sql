/****** Object:  Table [dbo].[GoodWord2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GoodWord2](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Word1] [varchar](150) NOT NULL,
	[Word2] [varchar](150) NOT NULL,
	[IndustryId] [int] NOT NULL,
	[RootWord1] [varchar](100) NULL,
	[RootWord2] [varchar](100) NULL,
 CONSTRAINT [PK_GoodWord2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
