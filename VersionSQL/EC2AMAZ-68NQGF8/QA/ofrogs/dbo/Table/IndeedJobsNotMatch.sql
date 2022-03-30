/****** Object:  Table [dbo].[IndeedJobsNotMatch]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndeedJobsNotMatch](
	[Company] [varchar](max) NULL,
	[title] [varchar](max) NULL,
	[JobPosted] [varchar](max) NULL,
	[InsertedDate] [datetime] NULL,
	[typeofdate] [varchar](max) NULL,
	[Keyword] [varchar](max) NULL,
	[Location] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
