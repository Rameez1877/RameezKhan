/****** Object:  Table [dbo].[DomainTable]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DomainTable](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DomainName] [nvarchar](max) NULL,
	[PatternId] [int] NULL,
 CONSTRAINT [PK_DomainTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

Create trigger [dbo].[RemoveDomainDuplicates] on [dbo].[DomainTable]
For Insert
As
Begin
   With CTE_Duplicates as
   (select domainname,patternId,
    row_number() over(partition by domainname
	order by domainname
	) rownumber 
   from DomainTable  )  delete from CTE_Duplicates where rownumber!=1
End


ALTER TABLE [dbo].[DomainTable] ENABLE TRIGGER [RemoveDomainDuplicates]
