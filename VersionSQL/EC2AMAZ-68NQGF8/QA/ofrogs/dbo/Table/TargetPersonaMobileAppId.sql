/****** Object:  Table [dbo].[TargetPersonaMobileAppId]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaMobileAppId](
	[TargetPersonaId] [int] NOT NULL,
	[MobileAppId] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaMobileAppId] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaId] ASC,
	[MobileAppId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
