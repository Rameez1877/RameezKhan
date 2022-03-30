/****** Object:  Table [dbo].[TimeZone]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TimeZone](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[UtcOffset] [varchar](10) NOT NULL,
	[Area] [varchar](250) NULL,
 CONSTRAINT [PK_TimeZone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
