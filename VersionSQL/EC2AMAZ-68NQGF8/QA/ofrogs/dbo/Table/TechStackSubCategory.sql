﻿/****** Object:  Table [dbo].[TechStackSubCategory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TechStackSubCategory](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[StackType] [nvarchar](100) NULL,
	[StackCategoryId] [int] NULL,
	[ISACTIVE] [bit] NULL,
 CONSTRAINT [PK__TechStac__3214EC2788FFBA5F] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
