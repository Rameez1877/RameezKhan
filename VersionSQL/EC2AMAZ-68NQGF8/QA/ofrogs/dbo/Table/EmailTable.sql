/****** Object:  Table [dbo].[EmailTable]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmailTable](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserId] [int] NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[DomainName] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[PatternId] [int] NULL,
	[IsValid] [bit] NULL,
 CONSTRAINT [PK_EmailTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
create TRIGGER [dbo].[TR_UPDATE_EMAIL] 
   ON  [dbo].[EmailTable]
   AFTER UPDATE
AS 
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 Declare @EmailId int
 Declare @DomainName nvarchar(max)
 Declare @IsValid bit
 Declare @PatternId int

 IF update(IsValid)
 begin
 SELECT  @DomainName = DomainName,
   @PatternId = PatternId,
   @IsValid = IsValid
 from inserted

 print @IsValid
 select * from inserted

 if @IsValid = 1
 begin
  insert into DomainTable(DomainName, PatternId) values (@DomainName, @PatternId)
 end  
 end



END
ALTER TABLE [dbo].[EmailTable] ENABLE TRIGGER [TR_UPDATE_EMAIL]
