/****** Object:  Table [dbo].[LinkedinDataChampion]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedinDataChampion](
	[LinkedInDataID] [int] NOT NULL,
	[Name] [varchar](200) NULL,
	[Url] [varchar](500) NULL,
	[Organization] [varchar](500) NULL,
	[Designation] [varchar](500) NULL,
	[YearOfJoining] [int] NULL,
	[CurrentPosition] [varchar](500) NULL,
	[Summary] [varchar](2000) NULL,
	[Functionality] [varchar](100) NULL,
	[LastUpdatedDate] [date] NULL,
	[Keyword] [varchar](500) NULL,
	[TagId] [int] NULL,
	[Gender] [varchar](1) NULL,
	[SeniorityLevel] [varchar](100) NULL,
	[ResultantCountry] [varchar](100) NULL,
	[PreviousOrganization] [varchar](500) NULL,
	[PreviousOrganizationTagId] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[KeywordType] [varchar](100) NULL,
 CONSTRAINT [PK_LinkedInDataChampion] PRIMARY KEY CLUSTERED 
(
	[LinkedInDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
