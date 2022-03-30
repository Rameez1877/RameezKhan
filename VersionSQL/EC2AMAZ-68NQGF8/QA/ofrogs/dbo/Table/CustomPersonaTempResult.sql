/****** Object:  Table [dbo].[CustomPersonaTempResult]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CustomPersonaTempResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NULL,
	[EmployeeCount] [varchar](100) NULL,
	[Revenue] [varchar](100) NULL,
	[CountryName] [varchar](100) NULL,
	[IndustryName] [varchar](100) NULL,
	[Technology] [varchar](100) NULL,
	[Functionality] [varchar](100) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
