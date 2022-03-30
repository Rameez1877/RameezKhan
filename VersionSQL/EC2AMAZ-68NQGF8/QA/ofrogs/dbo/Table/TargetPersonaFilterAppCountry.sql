/****** Object:  Table [dbo].[TargetPersonaFilterAppCountry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaFilterAppCountry](
	[CountryId] [int] NOT NULL,
	[CountryName] [varchar](100) NOT NULL,
	[NoOfOrganizations] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaFilterAppCountry] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
