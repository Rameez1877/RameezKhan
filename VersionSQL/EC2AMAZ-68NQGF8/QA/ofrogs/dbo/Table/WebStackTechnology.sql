/****** Object:  Table [dbo].[WebStackTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebStackTechnology](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[WebStackTechnology] [varchar](100) NOT NULL,
	[AlternativeWebStackTechnology] [varchar](100) NULL,
	[WebStackSubCategoryId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [Pk_WebStackTechnology] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
