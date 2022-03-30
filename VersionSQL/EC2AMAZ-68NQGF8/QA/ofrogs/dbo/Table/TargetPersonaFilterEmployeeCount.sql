/****** Object:  Table [dbo].[TargetPersonaFilterEmployeeCount]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaFilterEmployeeCount](
	[EmployeeCount] [varchar](100) NOT NULL,
	[OrderNo] [int] NOT NULL,
	[NoOfOrganizations] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaFilterEmployeeCount] PRIMARY KEY CLUSTERED 
(
	[EmployeeCount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
