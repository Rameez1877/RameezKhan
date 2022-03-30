/****** Object:  Table [dbo].[AdoptionFrameworkTechnologyCategory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AdoptionFrameworkTechnologyCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](100) NULL,
	[TechnologyCategory] [varchar](100) NULL,
	[TechnologyCategoryId] [int] NULL,
	[IsActive] [bit] NULL,
	[StackTechnologyName] [varchar](100) NULL,
	[IsTechnology] [int] NULL,
 CONSTRAINT [PK_AdoptionFrameworkTechnologyCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
