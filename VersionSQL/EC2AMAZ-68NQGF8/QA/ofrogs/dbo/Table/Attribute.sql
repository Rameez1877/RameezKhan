/****** Object:  Table [dbo].[Attribute]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Attribute](
	[AttributeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AttributeName] [varchar](50) NULL,
	[AttributeType] [varchar](10) NULL,
 CONSTRAINT [PK__Attribut__C18929EAAD4D1F16] PRIMARY KEY CLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
