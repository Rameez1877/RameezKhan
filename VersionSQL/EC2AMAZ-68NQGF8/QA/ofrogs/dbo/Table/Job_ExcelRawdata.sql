/****** Object:  Table [dbo].[Job_ExcelRawdata]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Job_ExcelRawdata](
	[SearchOrg] [nvarchar](255) NULL,
	[BaseURL] [nvarchar](255) NULL,
	[JobName] [nvarchar](255) NULL,
	[JobURL] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[Job Desription] [nvarchar](255) NULL,
	[Posting Date] [nvarchar](255) NULL,
	[JobLocation] [nvarchar](255) NULL,
	[IsDuplicate] [int] NULL,
	[Org_Name] [varchar](255) NULL
) ON [PRIMARY]
