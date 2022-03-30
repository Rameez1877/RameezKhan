/****** Object:  Table [dbo].[SICIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SICIndustry](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Year] [int] NOT NULL,
	[SIC] [int] NOT NULL,
	[Industry] [varchar](100) NOT NULL
) ON [PRIMARY]
