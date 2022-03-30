/****** Object:  Table [dbo].[JobFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobFunctionality](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Functionality] [nvarchar](200) NULL,
	[FunctionalityName] [nvarchar](200) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
