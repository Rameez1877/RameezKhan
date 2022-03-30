/****** Object:  Table [dbo].[Country]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Country](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ContinentId] [int] NULL,
	[ShortName] [varchar](10) NULL,
	[CountryUrl] [varchar](250) NULL,
	[IsActive] [varchar](1) NULL,
	[GoogleAPI_cxValue] [varchar](66) NULL,
	[CountryURLForBing] [varchar](100) NULL,
	[BingAPIValue] [varchar](10) NULL,
	[CountryDialInCode] [varchar](7) NULL,
	[IsCached] [bit] NULL,
	[IsEnglishSpeaking] [bit] NULL,
	[IsApac] [bit] NULL,
	[Code] [varchar](4) NULL,
	[IsRegion] [int] NULL,
 CONSTRAINT [PK__COUNTRY__3214EC27787DCE80] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
