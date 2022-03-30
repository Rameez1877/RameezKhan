/****** Object:  Table [dbo].[TechStackTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TechStackTechnology](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[StackTechnology] [nvarchar](100) NULL,
	[StackTechnologyName] [nvarchar](100) NULL,
	[StackSubCategoryId] [int] NULL,
	[IsActive] [bit] NULL,
	[TagId] [int] NULL,
	[Source] [int] NULL,
	[Description] [varchar](4000) NULL,
	[IsOpenSource] [bit] NULL,
	[Vendor] [varchar](100) NULL,
 CONSTRAINT [pk_TechStackTechnology] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
