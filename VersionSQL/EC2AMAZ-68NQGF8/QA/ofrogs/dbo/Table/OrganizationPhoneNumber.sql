/****** Object:  Table [dbo].[OrganizationPhoneNumber]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationPhoneNumber](
	[OrganizationID] [int] NULL,
	[PhoneNumber] [varchar](500) NULL,
	[IsPhoneNumberRight] [varchar](4) NULL,
	[CountryId] [int] NULL
) ON [PRIMARY]
