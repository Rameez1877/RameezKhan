/****** Object:  Table [dbo].[OrganizationWikiData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationWikiData](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationName] [varchar](300) NULL,
	[WikiName] [varchar](300) NULL,
	[Timestamp] [datetime] NULL,
	[TradingName] [varchar](350) NULL,
	[NativeName] [varchar](350) NULL,
	[RomanizedName] [varchar](350) NULL,
	[FormerlyCalled] [varchar](350) NULL,
	[Type] [varchar](30) NULL,
	[TradedAs] [varchar](150) NULL,
	[ISIN] [char](12) NULL,
	[Industry] [varchar](300) NULL,
	[Genre] [varchar](300) NULL,
	[Fate] [varchar](300) NULL,
	[Predecessor] [varchar](300) NULL,
	[Successor] [varchar](300) NULL,
	[Founded] [date] NULL,
	[Founder] [varchar](300) NULL,
	[Headquarters] [varchar](300) NULL,
	[NumberOfLocations] [int] NULL,
	[AreaServed] [varchar](300) NULL,
	[KeyPeople] [varchar](300) NULL,
	[Products] [varchar](500) NULL,
	[Brands] [varchar](300) NULL,
	[ProductionOutput] [varchar](300) NULL,
	[Services] [varchar](500) NULL,
	[Currency] [varchar](30) NULL,
	[Revenue] [bigint] NULL,
	[OperatingIncome] [bigint] NULL,
	[NetIncome] [bigint] NULL,
	[AUM] [bigint] NULL,
	[TotalAssets] [bigint] NULL,
	[TotalEquity] [bigint] NULL,
	[Owner] [varchar](300) NULL,
	[Members] [decimal](18, 0) NULL,
	[NumberOfEmployees] [int] NULL,
	[Parent] [varchar](300) NULL,
	[Divisions] [varchar](300) NULL,
	[Subsidiaries] [varchar](300) NULL,
	[CapitalRatio] [decimal](6, 2) NULL,
	[Website] [varchar](300) NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK__tmp_ms_x__3214EC07492D31FE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationWikiData] ADD  CONSTRAINT [DF__tmp_ms_xx__Times__49C3F6B7]  DEFAULT (sysdatetime()) FOR [Timestamp]
