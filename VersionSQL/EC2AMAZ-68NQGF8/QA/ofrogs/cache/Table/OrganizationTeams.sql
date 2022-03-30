/****** Object:  Table [cache].[OrganizationTeams]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [cache].[OrganizationTeams](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NULL,
	[CountryId] [int] NULL,
	[TeamName] [varchar](200) NULL,
	[InsertDate] [datetime] NULL,
	[IsOutSourcing] [bit] NULL,
	[IsBPO] [bit] NULL,
 CONSTRAINT [PK__Organiza__3214EC0727F65290] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
