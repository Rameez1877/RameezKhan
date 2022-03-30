/****** Object:  Table [dbo].[TargetPersonaFilterAppCategory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaFilterAppCategory](
	[AppCategoryId] [int] NOT NULL,
	[AppCategoryName] [varchar](100) NOT NULL,
	[NoOfOrganizations] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaFilterAppCategory] PRIMARY KEY CLUSTERED 
(
	[AppCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
