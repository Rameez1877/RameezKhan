/****** Object:  Table [dbo].[SurgeDashBoard]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SurgeDashBoard](
	[UserId] [int] NULL,
	[FilterType] [varchar](50) NULL,
	[DataString1] [varchar](500) NULL,
	[DataCount] [int] NULL,
	[OrderNumber] [int] NULL,
	[DataString2] [varchar](500) NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SurgeDashBoard] ADD  DEFAULT (getdate()) FOR [InsertedDate]
