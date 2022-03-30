/****** Object:  Table [dbo].[McDecisionmakerlistNewHire]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[McDecisionmakerlistNewHire](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DecisionMakerId] [int] NULL,
	[DecisionMakerlistName] [varchar](202) NULL,
	[Name] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_McDecisionmakerlistNewHire] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
