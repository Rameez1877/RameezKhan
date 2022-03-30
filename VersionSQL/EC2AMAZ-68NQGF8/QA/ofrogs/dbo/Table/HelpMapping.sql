/****** Object:  Table [dbo].[HelpMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HelpMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PlatformPath] [varchar](500) NOT NULL,
	[HelpPath] [varchar](500) NOT NULL,
 CONSTRAINT [PK_HelpMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
