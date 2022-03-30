/****** Object:  Table [dbo].[OldCategory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OldCategory](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LabelId] [int] NOT NULL,
	[IndustryId] [int] NOT NULL
) ON [PRIMARY]
