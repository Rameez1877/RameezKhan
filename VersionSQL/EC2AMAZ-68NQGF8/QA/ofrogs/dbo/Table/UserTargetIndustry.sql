/****** Object:  Table [dbo].[UserTargetIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTargetIndustry](
	[UserId] [int] NOT NULL,
	[IndustryId] [int] NOT NULL,
	[ApplyScore] [bit] NULL,
	[TargetPersonaId] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[UserTargetIndustry] ADD  DEFAULT ((1)) FOR [ApplyScore]
