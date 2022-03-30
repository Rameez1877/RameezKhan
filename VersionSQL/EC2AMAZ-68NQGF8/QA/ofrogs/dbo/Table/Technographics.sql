/****** Object:  Table [dbo].[Technographics]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Technographics](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Keyword] [varchar](116) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[CompanyName] [varchar](196) NULL,
	[TagId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[TagIdOrganization] [int] NULL,
	[IsUser] [bit] NULL,
	[ReferenceURL] [varchar](500) NULL,
	[EarliestJobPostDate] [date] NULL,
	[LatestJobPostDate] [date] NULL,
	[DataSource] [varchar](20) NULL,
	[OrganizationId] [int] NULL,
	[IsAgency] [bit] NULL,
 CONSTRAINT [PK_Technographics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Technographics_Indexes] ON [dbo].[Technographics]
(
	[Keyword] ASC,
	[OrganizationId] ASC
)
INCLUDE([CompanyName],[CountryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
