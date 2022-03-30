/****** Object:  Table [dbo].[StgLinkedinData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StgLinkedinData](
	[Row_Num] [int] NULL,
	[name] [nvarchar](1000) NULL,
	[url] [nvarchar](1000) NULL,
	[organization] [nvarchar](1000) NULL,
	[designation] [nvarchar](1000) NULL,
	[yearofjoining] [nvarchar](1000) NULL,
	[currentposition] [nvarchar](1000) NULL,
	[city] [nvarchar](1000) NULL,
	[state] [nvarchar](1000) NULL,
	[country] [nvarchar](1000) NULL,
	[summary] [nvarchar](max) NULL,
	[currentrole] [nvarchar](1000) NULL,
	[previousrole] [nvarchar](1000) NULL,
	[targetcustomer] [nvarchar](1000) NULL,
	[Functionality] [nvarchar](1000) NULL,
	[userid] [int] NULL,
	[keyword] [nvarchar](1000) NULL,
	[FirstName] [nvarchar](1000) NULL,
	[MiddleName] [nvarchar](1000) NULL,
	[LastName] [nvarchar](1000) NULL,
	[education] [nvarchar](1000) NULL,
	[domainname] [nvarchar](1000) NULL,
	[emailid] [nvarchar](1000) NULL,
	[phonenumber] [nvarchar](1000) NULL,
	[twitter] [nvarchar](1000) NULL,
	[linkedin_country] [nvarchar](1000) NULL,
	[suggested_domainname] [nvarchar](4000) NULL,
	[keywordType] [nvarchar](1000) NULL,
	[firstsuggested_domainname] [nvarchar](1000) NULL,
	[MarketingList] [varchar](500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
