/****** Object:  Table [dbo].[DashboardTeamData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DashboardTeamData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationID] [int] NULL,
	[EmployeeCount] [varchar](200) NULL,
	[Revenue] [varchar](200) NULL,
	[CountryName] [varchar](200) NULL,
	[IndustryName] [varchar](200) NULL,
	[Team] [varchar](200) NULL,
	[UserID] [int] NULL,
	[Functionality] [varchar](200) NULL,
	[Technology] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
