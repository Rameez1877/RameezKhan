/****** Object:  Table [dbo].[LinkedinDataNewHire]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedinDataNewHire](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Url] [varchar](500) NOT NULL,
	[Organization] [varchar](500) NOT NULL,
	[Designation] [varchar](500) NOT NULL,
	[ModifiedDesignation] [varchar](1000) NULL,
	[DateOfJoining] [varchar](100) NULL,
	[MonthOfJoining] [int] NULL,
	[YearOfJoining] [int] NULL,
	[CurrentPosition] [varchar](500) NULL,
	[Summary] [varchar](2000) NULL,
	[Functionality] [varchar](100) NULL,
	[LastUpdatedDate] [date] NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Keyword] [varchar](500) NULL,
	[TagId] [int] NULL,
	[Gender] [varchar](1) NULL,
	[SeniorityLevel] [varchar](100) NULL,
	[ResultantCountry] [varchar](100) NULL,
	[CountryOfOrigin] [varchar](150) NULL,
	[FirstName] [varchar](250) NULL,
	[MiddleName] [varchar](250) NULL,
	[LastName] [varchar](250) NULL,
	[AggressionLevel] [varchar](50) NULL,
	[Ethnicity] [varchar](100) NULL,
	[StagingId] [int] NULL,
	[OrganizationId] [int] NULL,
	[KeywordType] [varchar](24) NULL,
	[WorkOrderId] [int] NULL,
	[UniqueId] [int] NULL,
	[EmployementDuration] [int] NULL,
	[WorkAniversaryMonth] [varchar](10) NULL,
	[DateOfJoining2] [datetime] NULL,
 CONSTRAINT [pk_LinkedinDataNewHire] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
