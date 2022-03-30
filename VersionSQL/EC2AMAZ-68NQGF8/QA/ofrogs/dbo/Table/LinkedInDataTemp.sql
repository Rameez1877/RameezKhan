/****** Object:  Table [dbo].[LinkedInDataTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedInDataTemp](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[name] [varchar](max) NULL,
	[url] [varchar](max) NULL,
	[organization] [varchar](max) NULL,
	[designation] [varchar](max) NULL,
	[yearofjoining] [varchar](max) NULL,
	[currentposition] [varchar](max) NULL,
	[city] [varchar](max) NULL,
	[state] [varchar](max) NULL,
	[country] [varchar](max) NULL,
	[summary] [varchar](max) NULL,
	[currentrole] [varchar](max) NULL,
	[previousrole] [varchar](max) NULL,
	[targetcustomer] [varchar](max) NULL,
	[decisionmaker] [varchar](max) NULL,
	[Functionality] [varchar](100) NOT NULL,
	[userid] [int] NULL,
	[lastupdateddate] [varchar](max) NULL,
	[keyword] [varchar](500) NULL,
	[FirstName] [varchar](max) NOT NULL,
	[MiddleName] [varchar](max) NOT NULL,
	[LastName] [varchar](max) NOT NULL,
	[education] [varchar](max) NOT NULL,
	[domainname] [varchar](max) NOT NULL,
	[emailid] [varchar](max) NOT NULL,
	[TagId] [int] NOT NULL,
	[phonenumber] [varchar](max) NOT NULL,
	[score] [int] NOT NULL,
	[twitter] [varchar](max) NOT NULL,
	[linkedin_country] [varchar](max) NOT NULL,
	[suggested_domainname] [varchar](max) NOT NULL,
	[GoldCustomer] [bit] NOT NULL,
	[datarating] [int] NOT NULL,
	[fcount] [int] NOT NULL,
	[accuracy] [int] NOT NULL,
	[tagidold] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[OrganizationAccuracy] [int] NOT NULL,
	[keywordType] [varchar](max) NOT NULL,
	[firstsuggested_domainname] [varchar](max) NOT NULL,
	[lastupdatedon] [datetime] NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[AggressionLevel] [varchar](20) NULL,
	[CountryOfOrigin] [varchar](100) NOT NULL,
	[EmailVerificationStatus] [varchar](50) NULL,
	[IndustryID] [int] NULL,
	[emailgeneratedby] [varchar](max) NOT NULL,
	[source] [varchar](30) NULL,
	[datadotcomid] [int] NULL,
	[SeniorityLevel] [varchar](30) NULL,
	[ResultantCountry] [varchar](100) NULL,
	[EducationLevel] [varchar](25) NULL,
	[Motivation] [varchar](25) NULL,
	[Ethnicity] [varchar](50) NULL,
 CONSTRAINT [PK_LinkedInDataTemp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [FirstName]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [MiddleName]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [LastName]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [education]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [domainname]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [emailid]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [TagId]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [phonenumber]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [score]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [twitter]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [linkedin_country]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [suggested_domainname]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [GoldCustomer]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [datarating]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [fcount]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [accuracy]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [keywordType]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [firstsuggested_domainname]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT (getdate()) FOR [lastupdatedon]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('U') FOR [gender]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('None') FOR [AggressionLevel]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT (' ') FOR [CountryOfOrigin]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('Not Verified') FOR [EmailVerificationStatus]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ((0)) FOR [IndustryID]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT ('') FOR [emailgeneratedby]
ALTER TABLE [dbo].[LinkedInDataTemp] ADD  DEFAULT (N'Others') FOR [SeniorityLevel]
