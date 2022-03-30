/****** Object:  Table [dbo].[UserFilters]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserFilters](
	[ID] [int] NULL,
	[FilterType] [varchar](500) NULL,
	[Category] [varchar](500) NULL,
	[Data] [varchar](500) NULL,
	[DataString] [varchar](500) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
