/****** Object:  Table [dbo].[LabelMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LabelMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[ActualLabel] [nvarchar](500) NOT NULL,
	[DesiredLabel] [nvarchar](500) NOT NULL,
	[CreateDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_LabelMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
