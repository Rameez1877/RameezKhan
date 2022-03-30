/****** Object:  Table [dbo].[CustomersAccountList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CustomersAccountList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[CreatedBy] [int] NULL,
	[CategoryId] [int] NULL,
	[CreatedDate] [smalldatetime] NULL,
	[TotalAccounts] [int] NULL,
	[CustomerName] [varchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [Pk_CustomersAccountList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomersAccountList] ADD  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[CustomersAccountList] ADD  DEFAULT ((1)) FOR [IsActive]
