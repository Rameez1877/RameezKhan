/****** Object:  Table [dbo].[person_gender]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[person_gender](
	[person_name] [varchar](100) NULL,
	[gender] [varchar](2) NULL,
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CountryOfOrigin] [varchar](50) NULL,
	[Faith] [varchar](50) NULL
) ON [PRIMARY]
