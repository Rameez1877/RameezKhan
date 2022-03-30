/****** Object:  Table [ofuser].[CustomerTargetList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ofuser].[CustomerTargetList](
	[AppUserId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[NewsTagStatus] [int] NOT NULL,
	[IsActive] [int] NOT NULL,
	[existingcustomer] [varchar](100) NULL,
	[IsExistingCustomer] [bit] NULL,
	[magazineid] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AppUserId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [ofuser].[CustomerTargetList] ADD  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [ofuser].[CustomerTargetList] ADD  DEFAULT ((0)) FOR [magazineid]
ALTER TABLE [ofuser].[CustomerTargetList]  WITH NOCHECK ADD  CONSTRAINT [Fk_CustomerTargetList_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [ofuser].[CustomerTargetList] CHECK CONSTRAINT [Fk_CustomerTargetList_Organization]
