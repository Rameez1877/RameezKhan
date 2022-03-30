/****** Object:  Table [dbo].[MenuDev]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MenuDev](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Icon] [varchar](50) NULL,
	[ParentId] [int] NULL,
	[Path] [varchar](500) NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
