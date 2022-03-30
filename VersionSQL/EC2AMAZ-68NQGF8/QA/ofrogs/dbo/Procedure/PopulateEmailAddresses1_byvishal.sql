/****** Object:  Procedure [dbo].[PopulateEmailAddresses1_byvishal]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[PopulateEmailAddresses1_byvishal] (@p_UserId int, 
    @p_FirstName nvarchar(max), 
    @p_LastName nvarchar(max), 
    @p_DomainName nvarchar(max), @p_PatternId int)
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 Declare @PatternId int
 Declare @Pattern nvarchar(max)
 Declare @EmailAddess nvarchar(max)

 Declare @firstLetterOfFirstName nvarchar(1)
 Declare @firstLetterOfLastName nvarchar(1)

 DECLARE @PatternCursor as CURSOR
    -- Insert statements for procedure here
 if @p_PatternId > 0
 begin
    if @p_PatternId = 1 
    begin
      set @EmailAddess = CONCAT(@p_FirstName, @p_LastName, '@', @p_DomainName)
     -- select 'hello 1' + @EmailAddess
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 1, @p_PatternId)
    end
   else if @p_PatternId = 2
    begin

     set @firstLetterOfFirstName = substring(@p_FirstName, 1,1)
     set @EmailAddess = CONCAT(@firstLetterOfFirstName, @p_LastName, '@', @p_DomainName)
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 1, @p_PatternId)
    end
   else if @p_PatternId = 3
    begin
     set @EmailAddess = CONCAT(@p_FirstName, '@', @p_DomainName)
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 1, @p_PatternId)
    end
    else if @p_PatternId = 4
    begin
     
     set @firstLetterOfLastName = substring(@p_LastName, 1,1)
     set @EmailAddess = CONCAT(@p_FirstName, @firstLetterOfLastName, '@', @p_DomainName)
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 1, @p_PatternId)
     end
 end
 else
 if @p_PatternId = 0
  begin
      SET @PatternCursor = CURSOR FOR Select Id, Patterns from PatternTable 

 Open @PatternCursor
 Fetch Next from @PatternCursor into @PatternId, @Pattern
 While @@FETCH_STATUS = 0
 begin
  --select @PatternId, @Pattern
   if @PatternId = 1 
    begin
      set @EmailAddess = CONCAT(@p_FirstName, @p_LastName, '@', @p_DomainName)
      select @EmailAddess
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId)
    end
   else if @PatternId = 2
    begin
     set @firstLetterOfFirstName = substring(@p_FirstName, 1,1)
     set @EmailAddess = CONCAT(@firstLetterOfFirstName, @p_LastName, '@', @p_DomainName)
     select @EmailAddess
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId)
    end
   else if @PatternId = 3
    begin
     set @EmailAddess = CONCAT(@p_FirstName, '@', @p_DomainName)
     select @EmailAddess
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId)
    end
    else if @PatternId = 4
    begin
     set @firstLetterOfLastName = substring(@p_LastName, 1,1)
     set @EmailAddess = CONCAT(@p_FirstName, @firstLetterOfLastName, '@', @p_DomainName)
     select @EmailAddess
     insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
     values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId)
    end
    
   Fetch Next from @PatternCursor into @PatternId, @Pattern

 end
     Close @PatternCursor
 Deallocate @PatternCursor
 end


END
