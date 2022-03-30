/****** Object:  Table [dbo].[MiscMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MiscMarketingList](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DecisionMakerId] [int] NULL,
	[DecisionMakerlistName] [varchar](max) NULL,
	[Name] [varchar](max) NOT NULL,
 CONSTRAINT [PK_MiscMarketingList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
