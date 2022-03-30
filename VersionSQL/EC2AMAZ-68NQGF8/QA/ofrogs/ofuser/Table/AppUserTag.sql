/****** Object:  Table [ofuser].[AppUserTag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ofuser].[AppUserTag](
	[AppUserId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AppUserId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [ofuser].[AppUserTag]  WITH NOCHECK ADD  CONSTRAINT [Fk_AppUserTag_Tag] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tag] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [ofuser].[AppUserTag] CHECK CONSTRAINT [Fk_AppUserTag_Tag]
