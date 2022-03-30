/****** Object:  Table [dbo].[LinkedInDataForURL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedInDataForURL](
	[group_id] [int] NOT NULL,
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
	[IsActive] [bit] NOT NULL,
	[OrganizationAccuracy] [int] NOT NULL,
	[keywordType] [varchar](max) NOT NULL,
	[firstsuggested_domainname] [varchar](max) NOT NULL,
	[lastupdatedon] [datetime] NOT NULL,
 CONSTRAINT [PK_LinkedInDataForURL] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [FirstName]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [MiddleName]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [LastName]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [education]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [domainname]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [emailid]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [TagId]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [phonenumber]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [score]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [twitter]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [linkedin_country]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [suggested_domainname]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [GoldCustomer]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [datarating]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [fcount]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((0)) FOR [accuracy]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [keywordType]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT ('') FOR [firstsuggested_domainname]
ALTER TABLE [dbo].[LinkedInDataForURL] ADD  DEFAULT (getdate()) FOR [lastupdatedon]
