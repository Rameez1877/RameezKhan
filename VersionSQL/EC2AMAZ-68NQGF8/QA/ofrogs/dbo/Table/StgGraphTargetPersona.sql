/****** Object:  Table [dbo].[StgGraphTargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StgGraphTargetPersona](
	[SequenceNo] [int] NULL,
	[DataType] [varchar](25) NULL,
	[DataString] [varchar](100) NULL,
	[DataValue] [int] NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[StgGraphTargetPersona] ADD  DEFAULT (getdate()) FOR [InsertedDate]
