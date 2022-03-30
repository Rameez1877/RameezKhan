/****** Object:  Table [dbo].[Params]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Params](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RelationId] [int] NULL,
	[Relation] [varchar](50) NULL,
	[RelationValue] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Params]  WITH NOCHECK ADD  CONSTRAINT [Fk_Params_Relation] FOREIGN KEY([RelationId])
REFERENCES [dbo].[Relation] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Params] CHECK CONSTRAINT [Fk_Params_Relation]
