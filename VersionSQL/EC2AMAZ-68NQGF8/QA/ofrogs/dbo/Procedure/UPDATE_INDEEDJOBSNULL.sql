/****** Object:  Procedure [dbo].[UPDATE_INDEEDJOBSNULL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE UPDATE_INDEEDJOBSNULL
AS
BEGIN

DECLARE @COMPANYNAME VARCHAR(MAX)
DECLARE @COMPANYCHECK VARCHAR(MAX)
DECLARE @ROWCOUNT INT

DECLARE Company CURSOR FOR
select  distinct Organization from SurgeContactDetail 
where  organization='3M Cogent' 
--and emailid='cliu@3m.com'

OPEN Company

FETCH NEXT FROM  Company INTO @COMPANYNAME

WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'Company'

SELECT @COMPANYCHECK = Organization FROM SurgeContactDetail WITH (NOLOCK) WHERE emailid LIKE'%' + @COMPANYNAME + '%'  
AND Organization = @COMPANYNAME
SELECT @ROWCOUNT = @@ROWCOUNT 

IF (@ROWCOUNT > 0)
BEGIN
PRINT 'Tagged Sucessfully'
  --update JobPostTechnologyArea_QA set IsTaggedWithTag = 1 where Organization = @COMPANYNAME
END
else
 
BEGIN
PRINT 'Tag Failed'
 
END
FETCH NEXT FROM  Company INTO @COMPANYNAME

END
close Company
DEALLOCATE Company
END
