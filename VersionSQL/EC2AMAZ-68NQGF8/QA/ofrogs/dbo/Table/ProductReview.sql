/****** Object:  Table [dbo].[ProductReview]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProductReview](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MagazineID] [int] NULL,
	[Feel] [float] NULL,
	[Look] [float] NULL,
	[Smell] [float] NULL,
	[Taste] [float] NULL,
	[Username] [varchar](max) NULL,
	[UserComment] [varchar](max) NULL,
	[CommentDate] [date] NULL,
	[RDev] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD FOREIGN KEY([MagazineID])
REFERENCES [dbo].[Magazine] ([Id])
