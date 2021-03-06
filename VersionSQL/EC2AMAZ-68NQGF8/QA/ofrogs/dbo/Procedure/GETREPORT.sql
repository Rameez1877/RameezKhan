/****** Object:  Procedure [dbo].[GETREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GETREPORT]
AS
BEGIN
--PERSONAS

SELECT *INTO #TEMP FROM
(
SELECT USERNAME,EMAIL,INSERTEDDATE,PERSONAIDS, ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(PersonaIds), ',', '.'), 1)) ,0) AS FIRST FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01' and IsActive =1	AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN Persona P ON Y.FIRST = P.ID

SELECT *INTO #TEMP1 FROM
(
SELECT USERNAME,EMAIL,INSERTEDDATE,PERSONAIDS, ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(PersonaIds), ',', '.'), 2)) ,0) AS SECOND FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01' and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN Persona P ON Y.SECOND = P.ID

SELECT * INTO #TEMP2
FROM
(
SELECT T.USERNAME,t.Email,t.InsertedDate, (ISNULL(T.Name,'')+','+ISNULL(T1.Name,'')) AS PERSONAS FROM #TEMP T
INNER JOIN #TEMP1 T1
ON T.USERNAME = T1.USERNAME
)P

--SELECT * FROM #TEMP2
--SELECT USERNAME,InsertedDate,IIF(PERSONAS= ',','',REPLACE(PERSONAS,',','')) AS PERSONAS FROM #TEMP2
--------------
--REGION

SELECT * INTO #TEMP3
FROM 
(
SELECT USERNAME,EMAIL,INSERTEDDATE, RegionIds,ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(RegionIds), ',', '.'), 1)) ,0) AS FIRST FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01'  and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN Region R ON Y.FIRST = R.ID

SELECT * INTO #TEMP4 FROM 
(
SELECT USERNAME,EMAIL,INSERTEDDATE,RegionIds,ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(RegionIds), ',', '.'), 2)),0) AS SECOND FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01' and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN Region R ON Y.SECOND = R.ID

SELECT * INTO #TEMP5 FROM 
(
SELECT USERNAME,EMAIL,INSERTEDDATE,RegionIds ,ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(RegionIds), ',', '.'), 1)) ,0) AS THIRD FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01'  and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)A
LEFT JOIN Region R ON A.THIRD = R.ID

SELECT * INTO #tEMP6 FROM
(
SELECT T4.USERNAME,t4.Email,t4.InsertedDate, (ISNULL(T3.Name,'')+','+ISNULL(T4.Name,'') +','+ISNULL(T5.Name,'')) AS REGIONANME FROM #TEMP3 T3 
INNER JOIN #TEMP4 T4 ON T3.USERNAME = T4.USERNAME INNER JOIN #TEMP4 T5 ON T3.USERNAME = T5.USERNAME
)J
--------------
--INDUSTRY GROUPS

SELECT * INTO #TEMP7 FROM
(
SELECT USERNAME,EMAIL,INSERTEDDATE,INDUSTRYGROUPIDS, ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(INDUSTRYGROUPIDS), ',', '.'), 1)) ,0) AS FIRST FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01' and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN IndustryGroup R ON Y.FIRST = R.ID

SELECT * INTO #TEMP8
FROM 
(
SELECT  USERNAME,EMAIL,INSERTEDDATE,INDUSTRYGROUPIDS, ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(INDUSTRYGROUPIDS), ',', '.'), 2)) ,0) AS SECOND FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01'  and IsActive =1 AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)Y
LEFT JOIN IndustryGroup R ON Y.SECOND = R.ID

SELECT * INTO #TEMP9 FROM
(
SELECT USERNAME,EMAIL,INSERTEDDATE,INDUSTRYGROUPIDS, ISNULL(REVERSE(PARSENAME(REPLACE(REVERSE(INDUSTRYGROUPIDS), ',', '.'), 3)) ,0) AS THIRD FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01'  AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%'
)A
LEFT JOIN IndustryGroup R ON A.THIRD = R.ID

SELECT * INTO #tEMP10 FROM
(
SELECT T7.USERNAME,t7.Email,t7.InsertedDate, (ISNULL(T7.Name,'')+','+ISNULL(T8.Name,'') +','+ISNULL(T9.Name,'')) AS INDUSTRYGROUP FROM #TEMP7 T7
INNER JOIN #TEMP8 T8 ON T7.USERNAME = T8.USERNAME INNER JOIN #TEMP9 T9 ON T7.USERNAME = T9.USERNAME
)J

SELECT Username,COUNT(*) AS TouchProfiles INTO #TEMP11 FROM APPUSER 
WHERE INSERTEDDATE>='2022-01-01' AND USERNAME NOT LIKE '%OCEANFROGS%' AND USERNAME NOT LIKE '%GMAIL.COM%' AND ID IN (SELECT AppUserID FROM TouchProfilesAppUsers)
and  IsActive =1 GROUP BY Username

SELECT T6.USERNAME,T6.InsertedDate,IIF(PERSONAS= ',','',REPLACE(PERSONAS,',',''))AS PERSONAS,IIF(REGIONANME= ',,','',REPLACE(REGIONANME,',,','')) AS REGIONAME ,IIF(INDUSTRYGROUP= ',,','',REPLACE(INDUSTRYGROUP,',,','')) AS INDUSTRYGROUP ,ISNULL(TouchProfiles,0) AS TouchedProfiles
FROM #tEMP6 T6 INNER JOIN #TEMP2 t2 ON T6.Username =T2.USERNAME inner join #TEMP10 T10 ON T6.Username =T10.USERNAME LEFT JOIN #TEMP11 T11 ON T6.Username =T11.USERNAME

DROP TABLE #TEMP,#TEMP1,#TEMP2,#TEMP3,#TEMP4,#TEMP5,#tEMP6,#TEMP7,#TEMP8,#TEMP9,#tEMP10,#tEMP11
END
