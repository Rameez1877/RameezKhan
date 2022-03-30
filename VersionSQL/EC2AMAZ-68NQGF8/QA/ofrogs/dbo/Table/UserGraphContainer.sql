/****** Object:  Table [dbo].[UserGraphContainer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserGraphContainer](
	[ID] [int] NULL,
	[GraphType] [varchar](200) NOT NULL,
	[BarName] [varchar](200) NULL,
	[DataCount] [int] NOT NULL,
	[OnboardedUser] [bit] NOT NULL,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
