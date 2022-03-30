/****** Object:  Table [cache].[DecisionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [cache].[DecisionMakers](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](max) NULL,
	[Url] [varchar](max) NULL,
	[OrganizationId] [int] NULL,
	[OrganizationName] [varchar](max) NULL,
	[Designation] [varchar](max) NULL,
	[Functionality] [varchar](max) NULL,
	[CountryId] [int] NULL,
	[CountryName] [varchar](100) NULL,
	[IndustryId] [int] NULL,
	[IndustryName] [varchar](1000) NULL,
	[SeniorityLevel] [varchar](30) NULL,
	[FirstName] [varchar](max) NULL,
	[MiddleName] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[FirstSuggestedDomain] [varchar](max) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Gender] [varchar](1) NULL,
	[TagId] [int] NULL,
	[IsNewHire] [bit] NULL,
	[IsChampion] [bit] NULL,
 CONSTRAINT [PK_DecisionMakers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CACHE_DECISIONMAKERS] ON [cache].[DecisionMakers]
(
	[OrganizationId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CACHE_DECISIONMAKERS_COUNTRYID] ON [cache].[DecisionMakers]
(
	[CountryId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_CACHE_DECISIONMAKERS_SENIORITYLEVEL] ON [cache].[DecisionMakers]
(
	[SeniorityLevel] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
