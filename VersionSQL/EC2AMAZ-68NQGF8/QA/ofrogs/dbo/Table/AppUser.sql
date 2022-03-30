/****** Object:  Table [dbo].[AppUser]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppUser](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](200) NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [nvarchar](200) NULL,
	[Email] [varchar](150) NOT NULL,
	[AppRoleId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[BirthDate] [datetime] NULL,
	[Gender] [char](1) NULL,
	[Image] [nvarchar](max) NULL,
	[zerobounce_apikey] [varchar](200) NULL,
	[hunter_apikey] [varchar](200) NULL,
	[hunterapikey] [varchar](200) NULL,
	[ActivationCode] [varchar](50) NULL,
	[InsertedDate] [datetime] NULL,
	[NumberOfCountriesAllowed] [int] NULL,
	[NumberOfMarketingListsAllowed] [int] NULL,
	[OrganizationName] [varchar](100) NULL,
	[IsNewUser] [bit] NULL,
	[IsForMarketing] [bit] NULL,
	[EmailsForMarketing] [varchar](500) NULL,
	[Designation] [nvarchar](50) NULL,
	[Phone] [varchar](20) NULL,
	[PersonaIds] [varchar](2000) NULL,
	[CustomerType] [varchar](100) NULL,
	[RegionIds] [varchar](100) NULL,
	[IndustryGroupIds] [varchar](100) NULL,
	[RevenueCategoryIds] [varchar](50) NULL,
	[StackTechnologyNameIds] [varchar](50) NULL,
	[MobileAppCategoryIDs] [varchar](100) NULL,
	[MobileAppRegionIds] [varchar](100) NULL,
	[MobileAppIndustryGroupIds] [varchar](100) NULL,
	[PartnerPersonaID] [varchar](200) NULL,
	[PartnerRegionID] [varchar](200) NULL,
	[PartnerIndustryGroupID] [varchar](200) NULL,
	[IsOnboardingComplete] [bit] NULL,
	[CustomTechnologyPersonaID] [varchar](5000) NULL,
	[CustomIntentPersonaID] [varchar](200) NULL,
	[CustomTeamPersonaID] [varchar](200) NULL,
	[HasCustomPersona] [bit] NULL,
	[PasswordHash] [varbinary](max) NULL,
	[PasswordSalt] [varbinary](max) NULL,
 CONSTRAINT [PK_AppUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_AppUser] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [DF_Insert_Date]  DEFAULT (getdate()) FOR [InsertedDate]
ALTER TABLE [dbo].[AppUser] ADD  DEFAULT ((10)) FOR [NumberOfCountriesAllowed]
ALTER TABLE [dbo].[AppUser] ADD  DEFAULT ((7)) FOR [NumberOfMarketingListsAllowed]
ALTER TABLE [dbo].[AppUser] ADD  DEFAULT ((1)) FOR [IsNewUser]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [DF_PersonaIds]  DEFAULT ('') FOR [PersonaIds]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [df_Regionids]  DEFAULT ('') FOR [RegionIds]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [df_industrygroupids]  DEFAULT ('') FOR [IndustryGroupIds]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [df_stackTechnologyNameIds]  DEFAULT ('') FOR [StackTechnologyNameIds]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [DF_boardingComplete]  DEFAULT ((0)) FOR [IsOnboardingComplete]
ALTER TABLE [dbo].[AppUser] ADD  CONSTRAINT [DF_custompersona]  DEFAULT ((1)) FOR [HasCustomPersona]
