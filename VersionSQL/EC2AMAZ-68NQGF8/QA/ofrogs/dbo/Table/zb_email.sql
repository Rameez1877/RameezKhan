/****** Object:  Table [dbo].[zb_email]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[zb_email](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmailAddress] [nvarchar](max) NOT NULL,
	[api_key] [nvarchar](max) NOT NULL,
	[status] [nvarchar](max) NOT NULL,
	[api_key1] [varchar](max) NOT NULL,
	[status1] [varchar](max) NOT NULL,
 CONSTRAINT [PK_zb_email] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[zb_email] ADD  DEFAULT ('') FOR [EmailAddress]
ALTER TABLE [dbo].[zb_email] ADD  DEFAULT ('') FOR [api_key]
ALTER TABLE [dbo].[zb_email] ADD  DEFAULT ('') FOR [status]
ALTER TABLE [dbo].[zb_email] ADD  DEFAULT ('') FOR [api_key1]
ALTER TABLE [dbo].[zb_email] ADD  DEFAULT ('') FOR [status1]
