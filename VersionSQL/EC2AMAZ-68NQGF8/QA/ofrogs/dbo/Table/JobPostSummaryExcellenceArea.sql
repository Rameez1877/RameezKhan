/****** Object:  Table [dbo].[JobPostSummaryExcellenceArea]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobPostSummaryExcellenceArea](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobPostId] [int] NULL,
	[TagIdOrganization] [int] NULL,
	[ExcellenceArea] [varchar](200) NULL,
 CONSTRAINT [pk_JobPostSummaryExcellenceArea] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
