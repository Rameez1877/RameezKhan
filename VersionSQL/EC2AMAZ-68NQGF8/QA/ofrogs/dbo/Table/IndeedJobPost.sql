/****** Object:  Table [dbo].[IndeedJobPost]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndeedJobPost](
	[Id] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TagTypeId] [varchar](10) NULL,
	[Keyword] [varchar](2000) NULL,
	[JobTitle] [varchar](max) NOT NULL,
	[CompanyName] [nvarchar](250) NULL,
	[Location] [varchar](2000) NULL,
	[Summary] [varchar](max) NULL,
	[JobPosted] [varchar](38) NULL,
	[InsertedDate] [datetime] NULL,
	[CountryCode] [varchar](10) NULL,
	[TagId] [int] NULL,
	[Url] [varchar](4000) NULL,
	[jobdate] [datetime] NULL,
	[jobDatedays] [varchar](30) NULL,
	[InsertedDate1] [date] NULL,
	[jobdays] [int] NOT NULL,
	[DecisionMaker] [int] NULL,
	[Source] [varchar](50) NULL,
	[TagIdOrganization] [int] NULL,
	[SeniorityLevel] [varchar](150) NULL,
	[IsTechnoGraphicsProcessed] [varchar](1) NULL,
	[SourceID] [int] NULL,
	[IsLabelled] [int] NULL,
	[EmploymentType] [varchar](100) NULL,
	[Website] [varchar](500) NULL,
	[OrganizationAboutUs] [varchar](2000) NULL,
	[IsKeyfrogsProcessed] [bit] NULL,
	[WorkOrderId] [int] NULL,
	[OrganizationId] [int] NULL,
	[TagType] [int] NULL,
 CONSTRAINT [PK_IndeedJobPost] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_IndeedJobPost_Indexes] ON [dbo].[IndeedJobPost]
(
	[TagIdOrganization] ASC,
	[SeniorityLevel] ASC
)
INCLUDE([JobTitle],[Summary]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_IndeedJobPost_WorkOrderIndex] ON [dbo].[IndeedJobPost]
(
	[WorkOrderId] ASC
)
INCLUDE([Id],[CompanyName],[Location],[CountryCode],[TagIdOrganization]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
