/****** Object:  Table [dbo].[EmployeeCountTechBaseCost]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmployeeCountTechBaseCost](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCount] [varchar](100) NULL,
	[BaseCost] [bigint] NULL
) ON [PRIMARY]
