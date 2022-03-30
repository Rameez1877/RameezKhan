/****** Object:  Table [dbo].[WeeklyReportLastMonthIntent]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WeeklyReportLastMonthIntent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NULL,
	[CountryName] [varchar](100) NULL,
	[Organization] [varchar](100) NULL,
	[Technology] [varchar](150) NULL,
	[TechnologyCategory] [varchar](150) NULL,
	[DecisionMaker] [varchar](150) NULL,
	[Designation] [varchar](500) NULL,
	[Url] [varchar](500) NULL,
	[SentDate] [smalldatetime] NULL,
	[SentMonth] [smallint] NULL,
	[SentYear] [smallint] NULL,
	[UserId] [int] NULL,
	[IsSent] [bit] NULL,
 CONSTRAINT [Pk_WeeklyReportLastMonthIntent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WeeklyReportLastMonthIntent] ADD  DEFAULT ((0)) FOR [IsSent]
