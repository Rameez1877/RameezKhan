/****** Object:  Table [dbo].[WeeklyReportTracking]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WeeklyReportTracking](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NULL,
	[SentDate] [datetime] NULL,
	[SentMonth] [varchar](20) NULL,
	[SentYear] [varchar](20) NULL,
	[UserId] [int] NULL,
	[ReportName] [varchar](100) NULL,
	[Organization] [varchar](100) NULL,
 CONSTRAINT [Pk_WeeklyReportTracking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
