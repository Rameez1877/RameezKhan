/****** Object:  Table [dbo].[TargetPersonaCountry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaCountry](
	[TargetPersonaId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaCountry] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaId] ASC,
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
