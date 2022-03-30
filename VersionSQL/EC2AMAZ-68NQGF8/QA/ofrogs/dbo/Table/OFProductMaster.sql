/****** Object:  Table [dbo].[OFProductMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OFProductMaster](
	[ProductID] [int] NOT NULL,
	[Name] [varchar](255) NULL,
	[IsActive] [varchar](255) NULL,
	[Sells_By_Region] [int] NULL,
	[Sells_By_Credit] [int] NULL,
 CONSTRAINT [Pk_OFProductMaster] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
