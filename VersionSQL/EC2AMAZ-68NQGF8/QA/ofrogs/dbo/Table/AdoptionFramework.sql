/****** Object:  Table [dbo].[AdoptionFramework]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AdoptionFramework](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](100) NULL,
	[Functionality] [varchar](100) NULL,
	[Hierarchy] [smallint] NULL,
	[FunnelTypeId] [smallint] NULL,
	[Intent] [bit] NULL,
	[DecisionMaker] [bit] NULL,
	[PersonaTypeId] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_AdoptionFramework] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
