/****** Object:  Table [dbo].[VendorMenu]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VendorMenu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Icon] [varchar](50) NULL,
	[ParentId] [int] NULL,
	[Path] [varchar](500) NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [Pk_VendorMenu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[VendorMenu] ADD  DEFAULT ((1)) FOR [IsActive]
