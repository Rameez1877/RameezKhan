/****** Object:  Table [dbo].[SubIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SubIndustry](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[IndustryId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Description] [varchar](1000) NULL,
	[IsOfList] [varchar](1) NOT NULL,
 CONSTRAINT [PK_SubIndustry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SubIndustry] ADD  CONSTRAINT [DF_SubIndustry_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[SubIndustry] ADD  DEFAULT ('N') FOR [IsOfList]
