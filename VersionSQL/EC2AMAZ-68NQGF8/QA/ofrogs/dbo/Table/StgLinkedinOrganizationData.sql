/****** Object:  Table [dbo].[StgLinkedinOrganizationData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StgLinkedinOrganizationData](
	[Id] [int] NULL,
	[Name] [nvarchar](1000) NULL,
	[Website] [nvarchar](500) NULL,
	[Founded] [int] NULL,
	[Industry] [nvarchar](500) NULL,
	[EmployeeCount] [nvarchar](50) NULL,
	[Locality] [nvarchar](500) NULL,
	[Country] [nvarchar](100) NULL,
	[CompanyLinkedin] [nvarchar](500) NULL,
	[CurrentEmployeeEstimate] [int] NULL,
	[TotalEmployeeEstimate] [int] NULL
) ON [PRIMARY]
