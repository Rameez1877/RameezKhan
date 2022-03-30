/****** Object:  Table [dbo].[AppUsers]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [nvarchar](500) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[AppRoleId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[Image] [nvarchar](max) NULL,
	[ActivationCode] [varchar](50) NULL,
	[InsertedDate] [datetime] NULL,
	[OrganizationName] [varchar](100) NULL,
	[IsNewUser] [bit] NULL,
	[Designation] [nvarchar](50) NULL,
	[Phone] [varchar](20) NULL,
	[PersonaIds] [varchar](2000) NULL,
	[CustomerType] [varchar](100) NULL,
	[RegionIds] [varchar](100) NULL,
	[IndustryGroupIds] [varchar](100) NULL,
	[IsOnboardingComplete] [bit] NULL,
	[CustomTechnologyPersonaID] [varchar](5000) NULL,
	[CustomIntentPersonaID] [varchar](200) NULL,
	[CustomTeamPersonaID] [varchar](200) NULL,
	[HasCustomPersona] [bit] NULL,
	[PasswordHash] [varbinary](max) NULL,
	[PasswordSalt] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
