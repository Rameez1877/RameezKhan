/****** Object:  Table [ofuser].[ProductDefinition]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ofuser].[ProductDefinition](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](5000) NULL,
	[AppUserId] [int] NOT NULL,
	[LabelId] [int] NULL,
	[Url] [varchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [ofuser].[ProductDefinition]  WITH CHECK ADD  CONSTRAINT [Fk_ProductDefinition_Label] FOREIGN KEY([LabelId])
REFERENCES [dbo].[Label] ([Id])
ALTER TABLE [ofuser].[ProductDefinition] CHECK CONSTRAINT [Fk_ProductDefinition_Label]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

create TRIGGER [ofuser].[ofuser_ProductDefinition_Prevent_delete]
ON [ofuser].[ProductDefinition]
INSTEAD OF DELETE AS
       BEGIN
          RAISERROR ('Removing ofuser_ProductDefinition entries prevented by trigger.  Contact your administrator', 16, 1)
       END
       RETURN


ALTER TABLE [ofuser].[ProductDefinition] ENABLE TRIGGER [ofuser_ProductDefinition_Prevent_delete]
