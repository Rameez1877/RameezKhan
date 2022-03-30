/****** Object:  Table [dbo].[temp_org]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[temp_org](
	[Profile URL] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[Phone] [nvarchar](255) NULL,
	[# of Contacts] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Updated] [nvarchar](255) NULL,
	[Rev] [nvarchar](255) NULL,
	[Emp] [nvarchar](255) NULL,
	[industry] [varchar](100) NULL,
	[subindustry] [varchar](100) NULL,
	[ownership] [varchar](25) NULL,
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IsProcessed] [varchar](1) NULL,
	[industryid] [int] NULL,
	[subindustryid] [int] NULL,
	[countryid] [int] NULL,
	[OF_OrganizationID] [int] NULL,
	[ExactMatch] [varchar](1) NULL,
	[updatetype] [varchar](20) NULL,
	[DataSet] [varchar](25) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[temp_org] ADD  DEFAULT ('N') FOR [ExactMatch]
