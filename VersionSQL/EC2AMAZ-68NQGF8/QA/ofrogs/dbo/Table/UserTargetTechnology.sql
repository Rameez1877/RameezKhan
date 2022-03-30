/****** Object:  Table [dbo].[UserTargetTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTargetTechnology](
	[UserID] [int] NOT NULL,
	[Technology] [varchar](100) NOT NULL,
	[ApplyScore] [bit] NULL,
	[TargetPersonaId] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[UserTargetTechnology] ADD  DEFAULT ((1)) FOR [ApplyScore]
