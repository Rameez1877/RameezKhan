/****** Object:  Table [dbo].[PartnerProductSolution]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PartnerProductSolution](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KeyWordCategoryID] [int] NULL,
	[Name] [varchar](200) NOT NULL,
	[Product= 0 & Solution= 1] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
