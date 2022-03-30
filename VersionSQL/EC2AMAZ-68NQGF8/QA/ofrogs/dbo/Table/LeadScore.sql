/****** Object:  Table [dbo].[LeadScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScore](
	[UserID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[Revenue] [varchar](30) NULL,
	[EmployeeCount] [varchar](30) NULL,
	[IndustryScore] [int] NULL,
	[RevenueScore] [int] NULL,
	[EmployeeCountScore] [int] NULL,
	[AuthorityScore] [int] NULL,
	[TimingScore] [int] NULL,
	[TotalScore] [int] NULL,
	[TYPE] [varchar](10) NOT NULL,
	[NoOfDownloads] [varchar](25) NULL,
	[AppName] [varchar](100) NULL,
	[AppCategoryID] [int] NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [idx_leadscore] ON [dbo].[LeadScore]
(
	[TotalScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[LeadScore] ADD  DEFAULT ('NON App') FOR [TYPE]
ALTER TABLE [dbo].[LeadScore]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScore] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScore] CHECK CONSTRAINT [CHK_TYPE_LeadScore]
