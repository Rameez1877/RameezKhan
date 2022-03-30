/****** Object:  Procedure [dbo].[PopulateEmailAddresses]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PopulateEmailAddresses] (@p_UserId int, 
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
 Declare @Isvalid int
 DECLARE @PatternCursor as CURSOR
 declare @i as int

  set @firstLetterOfFirstName = substring(@p_FirstName, 1,1)
  set @firstLetterOfLastName = substring(@p_LastName, 1,1)

    set @firstLetterOfFirstName = Lower(@firstLetterOfFirstName)
  set @firstLetterOfLastName = Lower(@firstLetterOfLastName)      
		 set @p_FirstName = Lower(@p_FirstName)
  set @p_LastName = Lower(@p_LastName)      
      -- Insert statements for procedure here
 if @p_PatternId > 0
   
      begin
	      if @p_PatternId = 1 
			  begin      set @EmailAddess = CONCAT(@p_FirstName, @p_LastName, '@', @p_DomainName)    end
		   else if @p_PatternId = 2
			   begin       set @EmailAddess = CONCAT(@firstLetterOfFirstName, @p_LastName, '@', @p_DomainName)     end
		   else if @p_PatternId = 3
			   begin       set @EmailAddess = CONCAT(@p_FirstName, '@', @p_DomainName)        end
		   else if @p_PatternId = 4
			   begin       set @EmailAddess = CONCAT(@p_FirstName, @firstLetterOfLastName, '@', @p_DomainName)    end
          else if @p_PatternId = 5
			   begin	   set @EmailAddess = CONCAT(@p_FirstName,'.', @p_LastName, '@', @p_DomainName) end
		  else if @p_PatternId = 6
		  	   begin set @EmailAddess = CONCAT(@p_FirstName,'+', @p_LastName, '@', @p_DomainName)  end
          else if @p_PatternId = 7
			   begin set @EmailAddess = CONCAT(@p_FirstName,'-', @p_LastName, '@', @p_DomainName) end
		  else if @p_PatternId = 8
			   begin set @EmailAddess = CONCAT(@p_FirstName,'_', @p_LastName, '@', @p_DomainName) end 
		  else if @p_PatternId = 9
			   begin set @EmailAddess = CONCAT(@p_FirstName,'.', @firstLetterOfLastName, '@', @p_DomainName) end
		  else if @p_PatternId = 10
               begin set @EmailAddess = CONCAT(@p_FirstName,'-', @firstLetterOfLastName, '@', @p_DomainName) end
          else if @p_PatternId = 11
	     	   begin   set @EmailAddess = CONCAT(@p_FirstName,'_', @firstLetterOfLastName, '@', @p_DomainName) end 
		  else if @p_PatternId = 12
			   begin set @EmailAddess = CONCAT(@firstLetterOfFirstName,'.', @p_LastName, '@', @p_DomainName)end
		 else if @p_PatternId = 13
			 begin set @EmailAddess = CONCAT(@firstLetterOfFirstName,'-', @p_LastName, '@', @p_DomainName)end
		 else if @p_PatternId = 14
		     begin set @EmailAddess = CONCAT(@firstLetterOfFirstName,'_', @p_LastName, '@', @p_DomainName)end
		 else if @p_PatternId = 15
			  begin set @EmailAddess = CONCAT(@p_LastName,'.', @p_FirstName, '@', @p_DomainName)end
		 else if @p_PatternId = 16
		      begin  set @EmailAddess = CONCAT(@firstLetterOfLastName, @p_FirstName, '@', @p_DomainName) end
		 else if @p_PatternId = 17
		      begin set @EmailAddess = CONCAT(@p_LastName, '@', @p_DomainName) end
	     else if @p_PatternId = 18
			begin  set @EmailAddess = CONCAT(@p_LastName, @firstLetterOfFirstName ,'@',@p_DomainName) end
		else if @p_PatternId = 19
			begin  set @EmailAddess = CONCAT(@firstLetterOfFirstName,'-', @firstLetterOfLastName ,'@',@p_DomainName) end

			 set @Isvalid = 1
		 insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		  values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, @Isvalid, @p_PatternId) 
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
			  insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		   else if @PatternId = 2
			   begin    
			      set @EmailAddess = CONCAT(@firstLetterOfFirstName, @p_LastName, '@', @p_DomainName)  
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		   else if @PatternId = 3
			   begin   
			       set @EmailAddess = CONCAT(@p_FirstName, '@', @p_DomainName)       
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		   else if @PatternId = 4
			   begin    
			      set @EmailAddess = CONCAT(@p_FirstName, @firstLetterOfLastName, '@', @p_DomainName)    
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
          else if @PatternId = 5
			   begin	
			      set @EmailAddess = CONCAT(@p_FirstName,'.', @p_LastName, '@', @p_DomainName)
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		  else if @PatternId = 6
		  	   begin 
			   set @EmailAddess = CONCAT(@p_FirstName,'+', @p_LastName, '@', @p_DomainName)  
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
          else if @PatternId = 7
			   begin 
			   set @EmailAddess = CONCAT(@p_FirstName,'-', @p_LastName, '@', @p_DomainName)
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		  else if @PatternId = 8
			   begin 
			   set @EmailAddess = CONCAT(@p_FirstName,'_', @p_LastName, '@', @p_DomainName) 
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		  else if @PatternId = 9
			   begin 
			   set @EmailAddess = CONCAT(@p_FirstName,'.', @firstLetterOfLastName, '@', @p_DomainName) 
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		  else if @PatternId = 10
               begin 
			   set @EmailAddess = CONCAT(@p_FirstName,'-', @firstLetterOfLastName, '@', @p_DomainName) 
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
          else if @PatternId = 11
	     	   begin 
			     set @EmailAddess = CONCAT(@p_FirstName,'_', @firstLetterOfLastName, '@', @p_DomainName) 
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		  else if @PatternId = 12
			   begin 
			   set @EmailAddess = CONCAT(@firstLetterOfFirstName,'.', @p_LastName, '@', @p_DomainName)
			   insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		 else if @PatternId = 13
			 begin 
			 set @EmailAddess = CONCAT(@firstLetterOfFirstName,'-', @p_LastName, '@', @p_DomainName)
			 insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		 else if @PatternId = 14
		     begin 
			 set @EmailAddess = CONCAT(@firstLetterOfFirstName,'_', @p_LastName, '@', @p_DomainName)
			 insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		 else if @PatternId = 15
			  begin
			   set @EmailAddess = CONCAT(@p_LastName,'.', @p_FirstName, '@', @p_DomainName)
			  insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		 else if @PatternId = 16
		      begin 
			   set @EmailAddess = CONCAT(@firstLetterOfLastName, @p_FirstName, '@', @p_DomainName) 
			  insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		 else if @PatternId = 17
		      begin 
			  set @EmailAddess = CONCAT(@p_LastName, '@', @p_DomainName) 
			  insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
	     else if @PatternId = 18
			begin
			  set @EmailAddess = CONCAT(@p_LastName, @firstLetterOfFirstName ,'@',@p_DomainName) 
			insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
		else if @PatternId = 19
			begin
			  set @EmailAddess = CONCAT(@firstLetterOfFirstName,'-', @firstLetterOfLastName ,'@',@p_DomainName) 
			insert into EmailTable (UserId, FirstName, LastName, DomainName, EmailAddress, IsValid, PatternId)
		      values (@p_UserId, @p_FirstName, @p_LastName, @p_DomainName, @EmailAddess, 0, @PatternId) 
		     end
   Fetch Next from @PatternCursor into @PatternId, @Pattern

 end
     Close @PatternCursor
 Deallocate @PatternCursor
 end


END
