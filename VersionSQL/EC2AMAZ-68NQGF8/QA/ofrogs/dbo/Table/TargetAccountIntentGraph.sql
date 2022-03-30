/****** Object:  Table [dbo].[TargetAccountIntentGraph]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetAccountIntentGraph](
	[TargetPersonaId] [int] NULL,
	[FilterType] [varchar](50) NULL,
	[DataString1] [varchar](500) NULL,
	[DataCount] [int] NULL,
	[OrderNumber] [int] NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[TargetAccountIntentGraph] ADD  DEFAULT (getdate()) FOR [InsertedDate]
