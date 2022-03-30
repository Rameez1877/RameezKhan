/****** Object:  Table [MASTER].[PersonaTechTeamIntent]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [MASTER].[PersonaTechTeamIntent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PersonaID] [int] NULL,
	[TechnologyFunctionalityID] [int] NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [MASTER].[PersonaTechTeamIntent]  WITH CHECK ADD FOREIGN KEY([PersonaID])
REFERENCES [dbo].[Persona] ([Id])
ALTER TABLE [MASTER].[PersonaTechTeamIntent]  WITH CHECK ADD FOREIGN KEY([TechnologyFunctionalityID])
REFERENCES [MASTER].[TechTeamIntent] ([ID])
