/****** Object:  Table [dbo].[Technologies]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Technologies](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TechnologyID] [int] NULL,
	[Technology] [varchar](300) NOT NULL,
	[SubCategoryID] [int] NOT NULL,
	[SubCategory] [varchar](300) NOT NULL,
	[MainCategoryID] [int] NULL,
	[MainCategory] [varchar](300) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
