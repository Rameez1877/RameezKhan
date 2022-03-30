/****** Object:  Table [dbo].[Organization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Organization](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[FullName] [varchar](250) NULL,
	[Name2] [nvarchar](500) NULL,
	[WebsiteUrl] [varchar](500) NULL,
	[Description] [nvarchar](4000) NULL,
	[CreatedById] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedById] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[region] [nvarchar](4000) NULL,
	[Category] [nvarchar](1000) NULL,
	[IndustryId] [int] NULL,
	[RegionId] [int] NULL,
	[WikiName] [varchar](250) NULL,
	[SectorId] [int] NULL,
	[CountryId] [int] NULL,
	[SubIndustryID] [int] NULL,
	[DataSource] [varchar](250) NULL,
	[Phone] [nvarchar](250) NULL,
	[Org_Ownership] [varchar](25) NULL,
	[Datadotcom_ID] [int] NULL,
	[EmployeeCount] [varchar](50) NULL,
	[Revenue] [varchar](50) NULL,
	[GlassDoorIndustry] [varchar](100) NULL,
	[WebsiteTitle] [varchar](500) NULL,
	[WebsiteDescription] [varchar](4000) NULL,
	[WebsiteKeywords] [varchar](4000) NULL,
	[GlassdoorDescription] [varchar](7000) NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
