/****** Object:  Table [dbo].[GlassdoorOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GlassdoorOrganization](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SearchCountry] [varchar](100) NULL,
	[SearchKeyword] [varchar](100) NULL,
	[Company] [varchar](100) NULL,
	[Website] [varchar](200) NULL,
	[GlassdoorIndustry] [varchar](150) NULL,
	[Rating] [varchar](100) NULL,
	[Headquarters] [varchar](200) NULL,
	[Size] [varchar](150) NULL,
	[Founded] [varchar](100) NULL,
	[Type] [varchar](150) NULL,
	[RevenueFromGlassdoor] [varchar](100) NULL,
	[Competitors] [varchar](300) NULL,
	[Reviews] [varchar](100) NULL,
	[Jobs] [varchar](100) NULL,
	[Salaries] [varchar](100) NULL,
	[Interviews] [varchar](100) NULL,
	[Benifits] [varchar](100) NULL,
	[Photos] [varchar](100) NULL,
	[GlassdoorUrl] [varchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[Source] [varchar](100) NULL,
	[Title] [varchar](7000) NULL,
	[Keyword] [varchar](7000) NULL,
	[Description] [varchar](7000) NULL,
	[IsWebDataPulled] [varchar](2) NULL,
	[Revenue] [varchar](100) NULL,
	[EmployeeCount] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[CountryID] [int] NULL,
	[IsProcessed] [varchar](1) NULL,
	[GlassdoorDescription] [varchar](7000) NULL,
	[IsAwardPulled] [varchar](1) NOT NULL,
	[InputType] [varchar](25) NOT NULL,
	[WebsiteMatchScore] [int] NULL,
	[Purpose] [varchar](200) NULL,
 CONSTRAINT [PK_GlassdoorOrg] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Company] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GlassdoorOrganization] ADD  CONSTRAINT [DF__Glassdoor__creat__55AC415D]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[GlassdoorOrganization] ADD  DEFAULT ('N') FOR [IsWebDataPulled]
ALTER TABLE [dbo].[GlassdoorOrganization] ADD  DEFAULT ('N') FOR [IsProcessed]
ALTER TABLE [dbo].[GlassdoorOrganization] ADD  DEFAULT ('N') FOR [IsAwardPulled]
