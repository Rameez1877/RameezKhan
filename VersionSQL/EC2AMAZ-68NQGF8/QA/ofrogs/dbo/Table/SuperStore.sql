/****** Object:  Table [dbo].[SuperStore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SuperStore](
	[OrderID] [nvarchar](255) NULL,
	[OrderDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
	[ShipMode] [nvarchar](255) NULL,
	[CustomerID] [nvarchar](255) NULL,
	[CustomerName] [nvarchar](255) NULL,
	[Segment] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[PostalCode] [float] NULL,
	[Region] [nvarchar](255) NULL,
	[ProductID] [nvarchar](255) NULL,
	[Category] [nvarchar](255) NULL,
	[SubCategory] [nvarchar](255) NULL,
	[ProductName] [nvarchar](255) NULL,
	[Sales] [float] NULL,
	[Quantity] [float] NULL,
	[Discount] [float] NULL,
	[Profit] [float] NULL
) ON [PRIMARY]
