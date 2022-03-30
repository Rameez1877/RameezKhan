/****** Object:  Table [dbo].[TargetPersonaTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaTechnology](
	[TargetPersonaId] [int] NOT NULL,
	[TechStackTechnologyTagId] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaTechnology] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaId] ASC,
	[TechStackTechnologyTagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
