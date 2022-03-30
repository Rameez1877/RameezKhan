/****** Object:  Table [dbo].[TargetPersonaFilterIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaFilterIndustry](
	[IndustryId] [int] NOT NULL,
	[IndustryName] [varchar](100) NOT NULL,
	[NoOfOrganizations] [int] NOT NULL,
	[IndustryGroup] [varchar](200) NULL,
	[IndustryGroupId] [int] NULL,
 CONSTRAINT [PK_TargetPersonaFilterIndustry] PRIMARY KEY CLUSTERED 
(
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
