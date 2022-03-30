/****** Object:  Table [MASTER].[PersonaFunctionalityForDecisionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [MASTER].[PersonaFunctionalityForDecisionMakers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PersonaID] [int] NULL,
	[Intent] [varchar](500) NOT NULL,
	[IntentID] [int] NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [MASTER].[PersonaFunctionalityForDecisionMakers]  WITH CHECK ADD FOREIGN KEY([IntentID])
REFERENCES [MASTER].[TechTeamIntent] ([ID])
ALTER TABLE [MASTER].[PersonaFunctionalityForDecisionMakers]  WITH CHECK ADD FOREIGN KEY([PersonaID])
REFERENCES [dbo].[Persona] ([Id])
