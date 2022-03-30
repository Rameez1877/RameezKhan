/****** Object:  Table [dbo].[MagazineTag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MagazineTag](
	[MagazineId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
 CONSTRAINT [PK_MagazineTag] PRIMARY KEY CLUSTERED 
(
	[MagazineId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MagazineTag]  WITH CHECK ADD  CONSTRAINT [FK_MagazineTag_Magazine] FOREIGN KEY([MagazineId])
REFERENCES [dbo].[Magazine] ([Id])
ALTER TABLE [dbo].[MagazineTag] CHECK CONSTRAINT [FK_MagazineTag_Magazine]
ALTER TABLE [dbo].[MagazineTag]  WITH CHECK ADD  CONSTRAINT [FK_MagazineTag_MagazineTag] FOREIGN KEY([MagazineId], [TagId])
REFERENCES [dbo].[MagazineTag] ([MagazineId], [TagId])
ALTER TABLE [dbo].[MagazineTag] CHECK CONSTRAINT [FK_MagazineTag_MagazineTag]
ALTER TABLE [dbo].[MagazineTag]  WITH NOCHECK ADD  CONSTRAINT [FK_MagazineTag_Tag] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tag] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[MagazineTag] CHECK CONSTRAINT [FK_MagazineTag_Tag]
