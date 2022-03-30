/****** Object:  Table [dbo].[OFModuleMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OFModuleMaster](
	[ModuleID] [int] NOT NULL,
	[DisplayName] [varchar](255) NULL,
	[Module] [varchar](255) NULL,
	[IsActive] [int] NULL,
	[Sells_By_credit] [int] NULL,
	[IntialCredit] [int] NULL,
	[UnitCredits] [int] NULL,
 CONSTRAINT [Pk_OFModuleMaster] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
