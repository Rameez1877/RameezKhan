/****** Object:  Table [dbo].[UserTargetFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTargetFunctionality](
	[UserID] [int] NOT NULL,
	[Functionality] [varchar](100) NOT NULL,
	[ApplyScore] [bit] NULL,
	[TargetPersonaId] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[UserTargetFunctionality] ADD  DEFAULT ((0)) FOR [ApplyScore]
