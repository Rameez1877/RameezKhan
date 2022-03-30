/****** Object:  Table [dbo].[Datadotcom_LinkedinData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Datadotcom_LinkedinData](
	[Profile URL] [nvarchar](255) NULL,
	[Full Name] [nvarchar](255) NULL,
	[First] [nvarchar](255) NULL,
	[Last] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Updated] [nvarchar](255) NULL,
	[UpdatedDate] [date] NULL,
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Isvalid] [varchar](1) NULL,
	[IsProcessed] [varchar](1) NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](200) NULL
) ON [PRIMARY]
