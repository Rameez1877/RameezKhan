/****** Object:  Table [dbo].[LinkedInData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedInData](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[name] [varchar](max) NULL,
	[url] [varchar](766) NULL,
	[organization] [varchar](618) NULL,
	[designation] [varchar](max) NULL,
	[yearofjoining] [varchar](40) NULL,
	[currentposition] [varchar](648) NULL,
	[city] [varchar](526) NULL,
	[state] [varchar](564) NULL,
	[country] [varchar](408) NULL,
	[summary] [varchar](4000) NULL,
	[currentrole] [varchar](250) NULL,
	[previousrole] [varchar](100) NULL,
	[targetcustomer] [varchar](40) NULL,
	[decisionmaker] [varchar](50) NULL,
	[Functionality] [varchar](200) NULL,
	[userid] [int] NULL,
	[lastupdateddate] [varchar](38) NULL,
	[keyword] [varchar](500) NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](258) NULL,
	[LastName] [varchar](100) NULL,
	[education] [varchar](60) NULL,
	[domainname] [varchar](100) NULL,
	[emailid] [varchar](96) NULL,
	[TagId] [int] NOT NULL,
	[phonenumber] [varchar](75) NULL,
	[score] [int] NOT NULL,
	[twitter] [varchar](500) NULL,
	[linkedin_country] [varchar](48) NULL,
	[suggested_domainname] [varchar](516) NULL,
	[GoldCustomer] [bit] NOT NULL,
	[datarating] [int] NOT NULL,
	[fcount] [int] NOT NULL,
	[accuracy] [int] NOT NULL,
	[tagidold] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[OrganizationAccuracy] [int] NOT NULL,
	[keywordType] [varchar](42) NULL,
	[firstsuggested_domainname] [varchar](122) NULL,
	[lastupdatedon] [datetime] NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[AggressionLevel] [varchar](20) NULL,
	[CountryOfOrigin] [varchar](100) NOT NULL,
	[EmailVerificationStatus] [varchar](50) NULL,
	[IndustryID] [int] NULL,
	[emailgeneratedby] [varchar](50) NULL,
	[source] [varchar](30) NULL,
	[datadotcomid] [int] NULL,
	[SeniorityLevel] [varchar](30) NULL,
	[ResultantCountry] [varchar](100) NULL,
	[EducationLevel] [varchar](25) NULL,
	[Motivation] [varchar](25) NULL,
	[Ethnicity] [varchar](50) NULL,
	[IsArchive] [bit] NULL,
	[StagingDataID] [int] NULL,
	[IsNewHire] [bit] NOT NULL,
	[ModifiedDesignation] [varchar](500) NULL,
	[IsChampion] [bit] NULL,
	[OrganizationId] [int] NULL,
	[ResultantCountryId] [int] NULL,
	[WorkOrderId] [int] NULL,
	[UniqueId] [int] NULL,
 CONSTRAINT [PK_LinkedInData] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_LinkedInData_Indexes] ON [dbo].[LinkedInData]
(
	[ResultantCountryId] ASC,
	[OrganizationId] ASC,
	[SeniorityLevel] ASC,
	[lastupdatedon] ASC,
	[id] ASC
)
INCLUDE([name],[url],[designation]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_LinkedInData_Indexes2] ON [dbo].[LinkedInData]
(
	[UniqueId] ASC
)
INCLUDE([url],[SeniorityLevel],[ResultantCountry],[OrganizationId],[ResultantCountryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
