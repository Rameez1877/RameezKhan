/****** Object:  Table [dbo].[MobileAPP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobileAPP](
	[ID] [int] NOT NULL,
	[AppName] [varchar](1000) NULL,
	[CompanyName] [varchar](1000) NULL,
	[Category] [varchar](1000) NULL,
	[Rating] [float] NULL,
	[Reviews] [int] NULL,
	[Installs] [varchar](2000) NULL,
	[Size] [varchar](2000) NULL,
	[Price] [varchar](2000) NULL,
	[ContentRating] [varchar](300) NULL,
	[LastUpdated] [varchar](300) NULL,
	[MinimumVersion] [varchar](300) NULL,
	[LatestVersion] [varchar](300) NULL,
	[OrganizationID] [int] NULL,
	[AppCategoryID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[lastupdateddate] [date] NULL,
	[Context] [varchar](100) NULL,
	[AppType] [varchar](100) NULL,
	[AppLogo] [varchar](300) NULL,
	[AppURL] [varchar](300) NULL,
	[AppDescription] [varchar](7000) NULL,
	[OperatingSystem] [varchar](100) NULL,
	[AuthorType] [varchar](300) NULL,
	[RatingType] [varchar](30) NULL,
	[PriceCurrency] [varchar](3) NULL,
	[OfferAvailability] [varchar](100) NULL,
	[DeveloperDetail] [varchar](4000) NULL,
	[Source] [varchar](100) NULL,
 CONSTRAINT [pk_MobileAPP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
