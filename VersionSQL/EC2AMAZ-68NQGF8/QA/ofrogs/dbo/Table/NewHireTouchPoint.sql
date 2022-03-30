/****** Object:  Table [dbo].[NewHireTouchPoint]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NewHireTouchPoint](
	[Id] [int] NULL,
	[Name] [varchar](200) NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[Designation] [varchar](2000) NULL,
	[DateOfJoining] [date] NULL,
	[Url] [varchar](200) NULL,
	[Country] [varchar](200) NULL,
	[EmailId] [varchar](200) NULL,
	[Touch Point] [varchar](200) NULL,
	[NewHire] [varchar](200) NULL,
	[OrganizationID] [int] NULL,
	[ResultantCountry] [varchar](200) NULL,
	[Organization] [varchar](500) NULL,
	[WebsiteURL] [varchar](500) NULL
) ON [PRIMARY]
