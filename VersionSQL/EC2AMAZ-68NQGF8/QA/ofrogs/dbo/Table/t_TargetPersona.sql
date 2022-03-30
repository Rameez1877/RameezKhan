/****** Object:  Table [dbo].[t_TargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[t_TargetPersona](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[EmployeeCounts] [varchar](3000) NULL,
	[Revenues] [varchar](3000) NULL,
	[HotAccounts] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[AppCategories] [varchar](3000) NULL,
	[NoOfDownloads] [varchar](3000) NULL,
	[Locations] [varchar](3000) NULL,
	[Industries] [varchar](3000) NULL,
	[Technologies] [varchar](3000) NULL,
	[Gics] [varchar](3000) NULL,
	[Segment] [varchar](100) NULL,
	[Products] [varchar](200) NULL,
	[Solutions] [varchar](200) NULL
) ON [PRIMARY]
