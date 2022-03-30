/****** Object:  Table [dbo].[TargetPersonaIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaIndustry](
	[TargetPersonaId] [int] NOT NULL,
	[IndustryId] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaIndustry] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaId] ASC,
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
