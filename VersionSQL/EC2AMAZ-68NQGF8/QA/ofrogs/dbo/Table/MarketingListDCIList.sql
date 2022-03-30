/****** Object:  Table [dbo].[MarketingListDCIList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingListDCIList](
	[id] [int] NOT NULL,
	[marketinglist_name] [varchar](500) NULL,
	[marketinglist_DmName] [varchar](500) NULL,
	[functionality] [varchar](100) NOT NULL,
	[targetcustomer] [varchar](500) NULL,
	[name] [varchar](500) NULL,
	[designation] [varchar](500) NULL,
	[summary] [varchar](4000) NULL,
	[url] [varchar](500) NULL,
	[city] [varchar](500) NULL,
	[country] [varchar](500) NULL,
	[decisionmaker] [varchar](500) NULL,
	[lastupdateddate] [varchar](500) NULL,
	[domainname] [varchar](500) NOT NULL,
	[emailid] [varchar](500) NOT NULL,
	[phonenumber] [varchar](500) NOT NULL,
	[score] [int] NOT NULL,
	[firstname] [varchar](500) NOT NULL,
	[lastname] [varchar](500) NOT NULL,
	[organization] [varchar](500) NULL,
	[state] [varchar](500) NULL,
	[linkedin_country] [varchar](500) NOT NULL,
	[suggested_domainname] [varchar](500) NOT NULL,
	[goldcustomer] [bit] NOT NULL,
	[firstsuggested_domainname] [varchar](500) NOT NULL,
	[emailverificationstatus] [varchar](20) NOT NULL,
	[industryid] [int] NULL,
	[userid] [int] NULL,
	[emailgeneratedby] [varchar](500) NOT NULL,
	[gendertype] [bit] NULL,
	[gender] [varchar](1) NOT NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [idx_MarketingListDCIList] ON [dbo].[MarketingListDCIList]
(
	[decisionmaker] ASC,
	[industryid] ASC,
	[marketinglist_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
