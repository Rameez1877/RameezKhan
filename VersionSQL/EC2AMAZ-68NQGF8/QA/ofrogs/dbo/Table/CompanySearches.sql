/****** Object:  Table [dbo].[CompanySearches]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CompanySearches](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[OrganizationName] [varchar](200) NULL,
	[IndustryIds] [varchar](max) NULL,
	[CountryIds] [varchar](500) NULL,
	[EmployeeCounts] [varchar](500) NULL,
	[Revenues] [varchar](500) NULL,
	[TechnologyNames] [varchar](5000) NULL,
	[GicCountryIds] [varchar](500) NULL,
	[Teams] [varchar](5000) NULL,
	[COEs] [varchar](2000) NULL,
	[Products] [varchar](5000) NULL,
	[solutions] [varchar](5000) NULL,
	[InsertedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[CompanySearches] ADD  CONSTRAINT [DF_Date]  DEFAULT (getdate()) FOR [InsertedDate]
