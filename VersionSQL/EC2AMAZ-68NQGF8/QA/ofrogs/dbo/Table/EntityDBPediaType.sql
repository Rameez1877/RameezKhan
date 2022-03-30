/****** Object:  Table [dbo].[EntityDBPediaType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EntityDBPediaType](
	[EntityId] [int] NOT NULL,
	[DBPediaTypeId] [int] NOT NULL,
 CONSTRAINT [Pk_EntityDBPediaType] PRIMARY KEY CLUSTERED 
(
	[EntityId] ASC,
	[DBPediaTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EntityDBPediaType]  WITH CHECK ADD  CONSTRAINT [FK_EntityDBPediaType_DBPediaType] FOREIGN KEY([DBPediaTypeId])
REFERENCES [dbo].[DBPediaType] ([Id])
ALTER TABLE [dbo].[EntityDBPediaType] CHECK CONSTRAINT [FK_EntityDBPediaType_DBPediaType]
ALTER TABLE [dbo].[EntityDBPediaType]  WITH CHECK ADD  CONSTRAINT [FK_EntityDBPediaType_Entity] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([Id])
ALTER TABLE [dbo].[EntityDBPediaType] CHECK CONSTRAINT [FK_EntityDBPediaType_Entity]
