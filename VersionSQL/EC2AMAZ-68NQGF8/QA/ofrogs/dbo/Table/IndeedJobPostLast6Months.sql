/****** Object:  Table [dbo].[IndeedJobPostLast6Months]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndeedJobPostLast6Months](
	[Id] [numeric](18, 0) NOT NULL,
	[TagTypeId] [varchar](max) NULL,
	[Keyword] [varchar](max) NOT NULL,
	[JobTitle] [varchar](max) NOT NULL,
	[CompanyName] [nvarchar](250) NULL,
	[Location] [varchar](max) NULL,
	[Summary] [varchar](max) NULL,
	[JobPosted] [varchar](max) NULL,
	[InsertedDate] [datetime] NULL,
	[CountryCode] [varchar](10) NULL,
	[TagId] [int] NULL,
	[Url] [varchar](max) NULL,
	[jobdate] [datetime] NULL,
	[jobDatedays] [varchar](max) NULL,
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
	[OrganizationId] [int] NULL,
 CONSTRAINT [PK__IndeedJo__3214EC0741EA905E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
