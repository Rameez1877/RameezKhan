/****** Object:  Procedure [dbo].[Update_targetcustomers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Update_targetcustomers] @userid int, @industryId varchar(max)

AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @id int,
          @tagid int =0
  DECLARE db_cursor_lidata_ml CURSOR LOCAL FOR
  SELECT top 100
    id
  FROM organization
  WHERE industryid = @industryId
  OPEN db_cursor_lidata_ml
  FETCH NEXT FROM db_cursor_lidata_ml INTO @id
  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT TOP 1
      @tagid = id
    FROM tag
    WHERE organizationid = @id
    AND tagtypeid = 1

    INSERT INTO ofuser.customertargetlist (appuserid, organizationid, newstagstatus, isactive, existingcustomer, isexistingcustomer, magazineid)
      VALUES (@userid, @id, @tagid, '1', 'No',0, 0)
    FETCH NEXT FROM db_cursor_lidata_ml INTO @id
  END
  CLOSE db_cursor_lidata_ml

  DEALLOCATE db_cursor_lidata_ml
END
