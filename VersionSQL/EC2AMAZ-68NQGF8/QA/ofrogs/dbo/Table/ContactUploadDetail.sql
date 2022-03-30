/****** Object:  Table [dbo].[ContactUploadDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ContactUploadDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContactUploadId] [int] NOT NULL,
	[Company] [nvarchar](1000) NOT NULL,
	[CompanyWebsiteURL] [varchar](1000) NULL,
	[CountryOfInterest] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[LinkedInUrl] [varchar](1000) NULL,
	[Title] [varchar](500) NULL,
	[Email] [varchar](100) NULL,
	[CustomerType] [varchar](100) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_ContactUploadDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
