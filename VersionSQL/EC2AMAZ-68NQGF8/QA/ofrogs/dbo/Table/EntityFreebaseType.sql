/****** Object:  Table [dbo].[EntityFreebaseType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EntityFreebaseType](
	[EntityId] [int] NOT NULL,
	[FreebaseTypeId] [int] NOT NULL,
 CONSTRAINT [Pk_EntityFreebaseType] PRIMARY KEY CLUSTERED 
(
	[EntityId] ASC,
	[FreebaseTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EntityFreebaseType]  WITH CHECK ADD  CONSTRAINT [Fk_EntityFreebaseType_Entity] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity] ([Id])
ON DELETE CASCADE
ALTER TABLE [dbo].[EntityFreebaseType] CHECK CONSTRAINT [Fk_EntityFreebaseType_Entity]
ALTER TABLE [dbo].[EntityFreebaseType]  WITH CHECK ADD  CONSTRAINT [Fk_EntityFreebaseType_FreebaseType] FOREIGN KEY([FreebaseTypeId])
REFERENCES [dbo].[FreebaseType] ([Id])
ON DELETE CASCADE
ALTER TABLE [dbo].[EntityFreebaseType] CHECK CONSTRAINT [Fk_EntityFreebaseType_FreebaseType]
