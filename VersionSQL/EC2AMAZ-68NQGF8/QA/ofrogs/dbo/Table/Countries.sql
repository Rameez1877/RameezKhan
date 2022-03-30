/****** Object:  Table [dbo].[Countries]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Countries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NULL,
	[Description] [varchar](5000) NULL,
	[Capital] [varchar](500) NULL,
	[Language] [varchar](200) NULL,
	[Lang] [varchar](5) NULL,
	[PrimeMinister] [varchar](200) NULL,
	[President] [varchar](200) NULL,
	[Population] [varchar](500) NULL,
	[Area] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[Code] [varchar](5) NULL,
	[ImageName] [varchar](50) NULL,
	[CurrencyCode] [varchar](10) NULL,
	[ContinentName] [varchar](100) NULL,
	[CountryCode] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Countries] ADD  DEFAULT ((1)) FOR [IsActive]
