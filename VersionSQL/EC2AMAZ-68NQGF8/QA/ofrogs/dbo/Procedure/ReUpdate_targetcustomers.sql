/****** Object:  Procedure [dbo].[ReUpdate_targetcustomers]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[ReUpdate_targetcustomers]
@id int ,@industryId varchar(max)
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @orgid int
DECLARE delete_tc CURSOR LOCAL FOR
	  select b.id as orgid from ofuser.customertargetlist a join organization b on a.organizationid= b.id
	  where a.AppUserId =@id  and b.IndustryId = @industryId
	 OPEN delete_tc
  FETCH NEXT FROM delete_tc INTO @orgid
  WHILE @@FETCH_STATUS = 0
  BEGIN
      delete from  ofuser.customertargetlist where appuserid=@id and organizationid=@orgid
  FETCH NEXT FROM delete_tc INTO @orgid
  END
  CLOSE delete_tc

  DEALLOCATE delete_tc
	
End	
