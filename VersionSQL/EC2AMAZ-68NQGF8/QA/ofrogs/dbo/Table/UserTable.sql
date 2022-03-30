/****** Object:  Table [dbo].[UserTable]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTable](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Domain] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserTable] PRIMARY KEY CLUSTERED 
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
create TRIGGER [dbo].[TR_INS_USERTABLE] 
   ON  [dbo].[UserTable]
   AFTER INSERT
AS 
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 Declare @UserId int
 Declare @FirstName nvarchar(max), @LastName nvarchar(max), @Domain nvarchar(max)

 /*
  Selecting the inserted record
 */

 --select * From inserted

 SELECT  @UserId = Id,
   @FirstName = FirstName,
   @LastName = LastName,
   @Domain = Domain
 from inserted

 --select @UserId, @FirstName, @LastName, @Domain

 /*
  Check if there is any domain entries available in the Domain Table
 */

 Declare @DomainId int, @PatternId int
 Declare @DomainName nvarchar(max)

 print @Domain

 DECLARE @DomainCursor as  CURSOR
    SET @DomainCursor = CURSOR FOR
 select Id, DomainName, PatternId
 from DomainTable where DomainName = @Domain

 declare @IsDomainExists bit = 0

 Open @DomainCursor
 begin
 Fetch Next from @DomainCursor into
  @DomainId, @DomainName, @PatternId
  print @@cursor_rows
  While @@FETCH_STATUS = 0
  begin
    set @IsDomainExists = 1
   select @DomainId, @DomainName, @PatternId
    print @Patternid
    exec PopulateEmailAddresses @UserId, @FirstName, @LastName, @DomainName, @PatternId
   Fetch Next from @DomainCursor into
   @DomainId, @DomainName, @PatternId
  end
  Close @DomainCursor
 Deallocate @DomainCursor
 end
 print 'Is Domain Exists ' + Cast(@IsDomainExists as varchar)
 if @IsDomainExists = 0 
  begin
   print 'No domain records found'
   --select 'Userid ', @UserId, @FirstName, @LastName
   exec PopulateEmailAddresses @UserId, @FirstName, @LastName, @Domain, 0
  end
 


     


    -- Insert statements for trigger here



END
ALTER TABLE [dbo].[UserTable] ENABLE TRIGGER [TR_INS_USERTABLE]
