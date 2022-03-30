/****** Object:  Table [dbo].[McDecisionmakerlist]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[McDecisionmakerlist](
	[Id] [int] NOT NULL,
	[AppUserId] [int] NOT NULL,
	[DecisionMakerId] [int] NULL,
	[DecisionMakerlistName] [varchar](202) NULL,
	[IsActive] [bit] NOT NULL,
	[Name] [varchar](86) NULL,
	[Mode] [varchar](20) NULL
) ON [PRIMARY]
