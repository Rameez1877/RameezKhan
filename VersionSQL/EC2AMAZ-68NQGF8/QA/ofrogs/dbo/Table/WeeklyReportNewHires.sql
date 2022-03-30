/****** Object:  Table [dbo].[WeeklyReportNewHires]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WeeklyReportNewHires](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Organization] [varchar](100) NULL,
	[Designation] [varchar](500) NULL,
	[DateOfJoining] [varchar](50) NULL,
	[Url] [varchar](500) NULL,
	[Template] [varchar](500) NULL,
	[UserId] [int] NULL,
	[SentDate] [smalldatetime] NULL,
	[IsSent] [bit] NULL,
 CONSTRAINT [Pk_WeeklyReportNewHires] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WeeklyReportNewHires] ADD  DEFAULT ((0)) FOR [IsSent]
