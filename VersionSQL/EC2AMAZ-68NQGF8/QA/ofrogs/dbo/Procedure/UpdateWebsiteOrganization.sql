/****** Object:  Procedure [dbo].[UpdateWebsiteOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[UpdateWebsiteOrganization]
AS
BEGIN

DECLARE @FirstWord VARCHAR(200)
DECLARE @SecondWord VARCHAR(200)
DECLARE @OrganizationId INT
DECLARE @OrganizationName NVARCHAR(500)

DECLARE @ThirdWord VARCHAR(100)
DECLARE @FourthWord VARCHAR(100)

DECLARE Fullword CURSOR LOCAL FOR  SELECT OrganizationId,OrganizationName FROM  [dbo].[WebsiteOrganizations] 
WHERE (LEN(OrganizationName) - LEN(REPLACE(OrganizationName, ' ', ''))) >=1


OPEN Fullword
FETCH NEXT FROM Fullword INTO @OrganizationId,@OrganizationName
WHILE @@FETCH_STATUS = 0
BEGIN
	
		SELECT @FirstWord=T.FIRSTWORD FROM 
		(SELECT  LOWER(Word) AS FIRSTWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =1
		)T
		SELECT @SecondWord= SECONDWORD FROM 
		(SELECT  LOWER(Word) AS SECONDWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =2
		)L

		PRINT CAST(@OrganizationId AS VARCHAR(50))+ ' '+@OrganizationName+ ' '+ @FirstWord +'-'+ @SecondWord 
		UPDATE [dbo].[WebsiteOrganizations]  SET TransformedName = @FirstWord +'-'+ @SecondWord WHERE OrganizationId = @OrganizationId
		


FETCH NEXT FROM Fullword INTO @OrganizationId,@OrganizationName
END
CLOSE Fullword
DEALLOCATE Fullword

DECLARE @OriginalOrganizationName NVARCHAR(500)

DECLARE FullwordONE CURSOR FOR  SELECT OrganizationId,OrganizationName,LOWER(OrganizationName) FROM  [dbo].[WebsiteOrganizations] 
WHERE (LEN(OrganizationName) - LEN(REPLACE(OrganizationName, ' ', ''))) <1


OPEN FullwordONE
FETCH NEXT FROM FullwordONE INTO @OrganizationId,@OriginalOrganizationName,@OrganizationName
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @OriginalOrganizationName+'-'+ @OrganizationName
		UPDATE [dbo].[WebsiteOrganizations]  SET TransformedName = @OrganizationName WHERE OrganizationId = @OrganizationId
		

FETCH NEXT FROM FullwordONE INTO @OrganizationId,@OriginalOrganizationName,@OrganizationName
END
CLOSE FullwordONE
DEALLOCATE FullwordONE

DECLARE Fullwordof CURSOR FOR  SELECT OrganizationId,OrganizationName FROM  [dbo].[WebsiteOrganizations] 
WHERE RIGHT(TransformedName,2)= 'of'


OPEN Fullwordof
FETCH NEXT FROM Fullwordof INTO @OrganizationId,@OrganizationName
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'OF'
	
		SELECT @FirstWord=T.FIRSTWORD FROM 
		(SELECT  LOWER(Word) AS FIRSTWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =1
		)T
		SELECT @SecondWord= SECONDWORD FROM 
		(SELECT  LOWER(Word) AS SECONDWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =2
		)L
		SELECT @ThirdWord= ThirdWord FROM 
		(SELECT  LOWER(Word) AS ThirdWord FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =3
		)L
		SELECT @FourthWord= @FourthWord FROM 
		(SELECT  LOWER(Word) AS ThirdWord FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =4
		)L
		
		PRINT CAST(@OrganizationId AS VARCHAR(50))+ ' '+@OrganizationName+ ' '+ @FirstWord +'-'+ @SecondWord+'-'+@ThirdWord+'-'+TRIM(ISNULL(@FourthWord,''))+'-'
		UPDATE [dbo].[WebsiteOrganizations]  SET TransformedName = @FirstWord +'-'+ @SecondWord+'-'+@ThirdWord
		--R+'-'+TRIM(ISNULL(@FourthWord,''))+'-'+TRIM(ISNULL(@FifthWord,''))
		WHERE OrganizationId = @OrganizationId
		


FETCH NEXT FROM Fullwordof INTO @OrganizationId,@OrganizationName
END
CLOSE Fullwordof
DEALLOCATE Fullwordof


--DECLARE FullwordAND CURSOR FOR  SELECT OrganizationId,OrganizationName FROM  [dbo].[WebsiteOrganizations] 
--WHERE RIGHT(TransformedName,1)= '&'


--OPEN FullwordAND
--FETCH NEXT FROM FullwordAND INTO @OrganizationId,@OrganizationName
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	PRINT '&'
--		SELECT @FirstWord=T.FIRSTWORD FROM 

--		(SELECT  LOWER(Word) AS FIRSTWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
--		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
--		RN =1
--		)T
--		SELECT @SecondWord= SECONDWORD FROM 
--		(SELECT  LOWER(Word) AS SECONDWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
--		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
--		RN =2
--		)L
--		SELECT @ThirdWord= ThirdWord FROM 
--		(SELECT  LOWER(Word) AS ThirdWord FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
--		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
--		RN =3
--		)L

--		PRINT CAST(@OrganizationId AS VARCHAR(50))+ ' '+@OrganizationName+ ' '+ @FirstWord +'-'+ @SecondWord+'-'+@ThirdWord
--		UPDATE [dbo].[WebsiteOrganizations]  SET TransformedName = REPLACE(@FirstWord +'-'+ @SecondWord+'-'+@ThirdWord,'-&','') WHERE OrganizationId = @OrganizationId
		


--FETCH NEXT FROM FullwordAND INTO @OrganizationId,@OrganizationName
--END
--CLOSE FullwordAND
--DEALLOCATE FullwordAND

UPDATE Q SET Q.TransformedName = REPLACE(Q.TransformedName,'-&','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE RIGHT(q.TransformedName,1)= '&'

UPDATE Q SET Q.TransformedName = TRIM('--' FROM Q.TransformedName) FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%--%'


UPDATE Q SET Q.TransformedName = TRIM(',' FROM Q.TransformedName) FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%,%'


UPDATE Q SET Q.TransformedName = TRIM('.' FROM Q.TransformedName) FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%.%'





DECLARE Fullwordthe CURSOR FOR  SELECT OrganizationId,OrganizationName FROM  [dbo].[WebsiteOrganizations] 
WHERE RIGHT(TransformedName,3)= 'the'


OPEN Fullwordthe
FETCH NEXT FROM Fullwordthe INTO @OrganizationId,@OrganizationName
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'the'
		SELECT @FirstWord=T.FIRSTWORD FROM 
		(SELECT  LOWER(Word) AS FIRSTWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =1
		)T
		SELECT @SecondWord= SECONDWORD FROM 
		(SELECT  LOWER(Word) AS SECONDWORD FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =2
		)L
		SELECT @ThirdWord= ThirdWord FROM 
		(SELECT  LOWER(Word) AS ThirdWord FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =3
		)L
		SELECT @FourthWord= FourthWord FROM 
		(SELECT  LOWER(Word) AS FourthWord FROM(SELECT Value AS Word, ROW_NUMBER()OVER(ORDER BY (SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations] WHERE OrganizationId =@OrganizationId)) RN
		FROM STRING_SPLIT((SELECT TRIM(OrganizationName) FROM [dbo].[WebsiteOrganizations]  WHERE OrganizationId =@OrganizationId), ' ')) T WHERE 
		RN =4
		)L

		PRINT CAST(@OrganizationId AS VARCHAR(50))+ ' '+@OrganizationName+ ' '+ @FirstWord +'-'+ @SecondWord+'-'+@ThirdWord+'-'+TRIM(ISNULL(@FourthWord,''))
		UPDATE [dbo].[WebsiteOrganizations]  SET TransformedName = @FirstWord +'-'+ @SecondWord+'-'+@ThirdWord+'-'+TRIM(ISNULL(@FourthWord,'')) WHERE OrganizationId = @OrganizationId
		


FETCH NEXT FROM Fullwordthe INTO @OrganizationId,@OrganizationName
END
CLOSE Fullwordthe
DEALLOCATE Fullwordthe


UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'INC','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE RIGHT(Q.TransformedName,3) = 'inc'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'LTD','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE RIGHT(Q.TransformedName,3) = 'LTD'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'LLC','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE RIGHT(Q.TransformedName,3) = 'LLC'

UPDATE Q SET Q.TransformedName = TRIM('-' FROM q.TransformedName ) FROM dbo.WebsiteOrganizations Q 
INNER JOIN dbo.WebsiteOrganizations t 
ON Q.OrganizationId = t.OrganizationId
WHERE RIGHT(Q.TransformedName,1) = '-'

UPDATE Q SET Q.TransformedName = REPLACE(Q.TransformedName,',','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%,%'


UPDATE Q SET Q.TransformedName = REPLACE(Q.TransformedName,'.','')  FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%.%'



UPDATE Q SET Q.TransformedName = REPLACE(Q.TransformedName,'''','') FROM dbo.WebsiteOrganizations Q 
INNER JOIN dbo.WebsiteOrganizations t 
ON Q.OrganizationId = t.OrganizationId
WHERE Q.TransformedName LIKE '%''%'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'(','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
where Q.TransformedName like '%(%'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,')','') FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
where Q.TransformedName like '%)%'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'/','-')FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
where Q.TransformedName like '%/%'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'*','')FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
where Q.TransformedName like '%*%'

UPDATE Q SET Q.TransformedName = REPLACE(q.TransformedName,'!','')FROM dbo.WebsiteOrganizations Q 
inner join dbo.WebsiteOrganizations t 
on Q.OrganizationId = t.OrganizationId
where Q.TransformedName like '%!%'




END
