/****** Object:  Procedure [dbo].[Create_magazine_Ontargetcustomer]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Create_magazine_Ontargetcustomer]
@userid int ,@organizationid int,@industryid int ,@tagid int


AS
BEGIN
	DECLARE @UserName varchar(1000)
        SET @UserName = 
        (
           select Name from Appuser where Id = @userid
        )
  --  DECLARE @industryid int
  --      SET @industryid = 
  --      (
		--select a.industryid from tag b left join  industrytag a on b.id=a.tagid where a.tagid=@tagid
		--)
	insert into magazine (Name,Industryid,CreateDate,IsActive,Organizationid)
                  values (@UserName,@industryid,getdate(),1,@organizationid)
				  
     DECLARE @magazineid int
        SET @magazineid = 
        (
		select id from magazine where Name=@UserName and Industryid=@industryid 
		                                and IsActive= 1 and organizationid=@organizationid
		)
		update ofuser.CustomertargetList set magazineid=@magazineid where appuserid=@userid and newstagstatus=@tagid
		insert into magazinetag(magazineid,tagid) values(@magazineid,@tagid)

	
End	
