/****** Object:  Table [dbo].[HubSpotSharedProfiles]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HubSpotSharedProfiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Url] [varchar](4000) NULL,
	[SharedDate] [smalldatetime] NULL,
	[Source] [varchar](100) NULL,
 CONSTRAINT [PK_HubSpotSharedProfiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[HubSpotSharedProfiles] ADD  DEFAULT (getutcdate()) FOR [SharedDate]
