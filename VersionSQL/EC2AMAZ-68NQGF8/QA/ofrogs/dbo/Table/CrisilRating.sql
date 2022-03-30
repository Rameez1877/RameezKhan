/****** Object:  Table [dbo].[CrisilRating]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CrisilRating](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationID] [int] NULL,
	[OrganizationName] [varchar](100) NOT NULL,
	[Industry] [varchar](100) NOT NULL,
	[Instrument] [varchar](100) NULL,
	[Rating] [varchar](100) NULL,
	[Outlook] [varchar](100) NULL,
	[InsertedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CrisilRating] ADD  DEFAULT (getdate()) FOR [InsertedDate]
