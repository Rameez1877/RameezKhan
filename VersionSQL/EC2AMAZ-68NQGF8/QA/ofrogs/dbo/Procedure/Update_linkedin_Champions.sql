/****** Object:  Procedure [dbo].[Update_linkedin_Champions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Update_linkedin_Champions] 
	@id int 
AS


BEGIN
	
	SET NOCOUNT ON;
	  
			DECLARE @MyCursor CURSOR;
			-- DECLARE @name varchar(1000);
			DECLARE @tagId int;
			BEGIN
				SET @MyCursor = CURSOR FOR
				--select distinct a.name
	            --from ofuser.customertargetlist b
              --  left join tag a on a.id=b.newstagstatus where appuserid=@id and existingcustomer='Yes'
	         select distinct newstagstatus
	          from ofuser.customertargetlist b    where appuserid=@id and existingcustomer='Yes'
				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @tagId

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					--update linkedindata set decisionmaker='Champions' where functionality= @Name and userid=@id
					update linkedindata set decisionmaker='Champions' where TagId=@tagId and userid=@id  and decisionmaker='DecisionMaker'
				  FETCH NEXT FROM @MyCursor 
				  INTO @tagId
				END; 
				CLOSE @MyCursor 
				DEALLOCATE @MyCursor
			END
END
