/****** Object:  Table [dbo].[DomainNameOrg]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DomainNameOrg](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Tagid] [int] NOT NULL,
	[TagName] [varchar](max) NULL,
	[DomainName] [varchar](max) NULL,
	[InsertionDate] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DomainNameOrg] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
