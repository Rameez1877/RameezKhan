/****** Object:  Table [dbo].[ProcessAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProcessAccounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TargetListName] [varchar](100) NULL,
	[UploadDate] [date] NULL,
	[UploadedBy] [varchar](100) NULL,
	[NumberOfAccounts] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
