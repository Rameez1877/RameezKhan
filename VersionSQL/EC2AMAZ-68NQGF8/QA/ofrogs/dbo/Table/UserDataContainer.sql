/****** Object:  Table [dbo].[UserDataContainer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserDataContainer](
	[DataType] [varchar](200) NULL,
	[OrganizationID] [int] NOT NULL,
	[DataString] [varchar](200) NOT NULL,
	[OnboardedUser] [bit] NOT NULL,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
