/****** Object:  Table [dbo].[CopyMcDecisionmakerlistNewHire]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CopyMcDecisionmakerlistNewHire](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DecisionMakerId] [int] NULL,
	[DecisionMakerlistName] [varchar](202) NULL,
	[Name] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
