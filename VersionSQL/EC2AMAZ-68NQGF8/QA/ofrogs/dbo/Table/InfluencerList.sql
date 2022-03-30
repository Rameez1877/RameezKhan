/****** Object:  Table [dbo].[InfluencerList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[InfluencerList](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Keyword] [varchar](28) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_InfluencerList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
