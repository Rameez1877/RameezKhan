/****** Object:  Table [dbo].[DashboardDataSummaryNEW]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DashboardDataSummaryNEW](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NULL,
	[EmployeeCount] [varchar](100) NULL,
	[Revenue] [varchar](100) NULL,
	[CountryName] [varchar](100) NULL,
	[IndustryName] [varchar](100) NULL,
	[Technology] [varchar](100) NULL,
	[Functionality] [varchar](100) NULL,
	[UserID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
