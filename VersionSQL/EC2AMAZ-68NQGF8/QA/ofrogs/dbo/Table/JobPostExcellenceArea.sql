/****** Object:  Table [dbo].[JobPostExcellenceArea]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobPostExcellenceArea](
	[JobPostID] [int] NOT NULL,
	[ExcellenceArea] [varchar](100) NULL,
	[Marketinglist] [varchar](100) NULL,
	[JobTitleKeyword] [varchar](500) NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_JobPostExcellenceArea] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
