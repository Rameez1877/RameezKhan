/****** Object:  Table [dbo].[AppUserSettings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppUserSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PersonaIds] [varchar](500) NULL,
	[CountryIds] [varchar](2000) NULL,
	[IndustryIds] [varchar](2000) NULL,
	[EmployeeCounts] [varchar](2000) NULL,
	[Revenues] [varchar](200) NULL,
	[TechnologyIds] [varchar](5000) NULL,
	[FunctionalityIds] [varchar](5000) NULL,
 CONSTRAINT [PK_AppUserSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
