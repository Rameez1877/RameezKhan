/****** Object:  Table [dbo].[TouchProfilesAppUsers]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TouchProfilesAppUsers](
	[AppUserID] [int] NULL,
	[NewHireProfileId] [int] NULL,
	[TouchDate] [date] NULL,
	[OrganizationID] [int] NULL,
	[IsTouched] [bit] NULL
) ON [PRIMARY]
